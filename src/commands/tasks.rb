require_relative 'command'

module BoiteABois
  module Commands
    # Tasks management for the BecauseOfProg team
    class Tasks < Command

      CATEGORY = 'teams'
      USAGE = 'tasks\n
  • list : Lister toutes les listes de tâches\n
  • create <nom> <titre> : Créer une liste de tâches\n
  • delete <nom> : Supprimer une liste de tâches\n
  • add <liste> <tâche> : Ajouter une tâche à une liste\n
  • delete <liste> <index> : Supprimer une tâche d\'une liste\n
  • purge <liste> : Supprimer toutes les tâches d\'une liste'
      DESC = 'Gérer les tâches du staff'
      CHANNELS = [531447997968547845, 482144683288428544]
      ROLES = [353973189363236864, 559822140153659424]
      SHOW = false

      # @return [Hash<Symbol,Lambda>] All the commands available for task management
      COMMANDS = {
        list:   lambda { |args, context| list_tasks(args, context) },
        create: lambda { |args, context| create_list(args, context) },
        delete: lambda { |args, context| delete_list(args, context) },
        add:    lambda { |args, context| add_task(args, context) },
        remove: lambda { |args, context| remove_task(args, context) },
        purge:  lambda { |args, context| purge_list(args, context) },
      }

      def self.exec(args, context)
        found = false
        COMMANDS.each do |name, function|
          if args[0] == name.to_s
            found = true
            function.call(args, context) 
          end
        end
        context.send ":x: Argument inconnu : #{args[0]}" unless found
      end

      # Find a task list
      #
      # @param name [String] Task list's name
      def self.find_list(name)
        ::Tasks.find(name: name).last
      end

      # Update the task list message
      #
      # @param context [Discordrb::Events::MessageEvent] The context in which the command is executed
      # @param task_list The task list to update
      def self.update_list(context, task_list)
        message = "**#{task_list.title} (#{task_list.name})**\n\n"
        task_list.tasks.each do |task|
          message << "• #{task}\n"
        end
        context.channel.message(task_list.message_id).edit(message)
        context.message.delete
      end

      # ------------------------ COMMANDS ------------------------

      # Command - List all the tasks
      def self.list_tasks(args, context)
        message = ''
        query = ::Tasks.find
        message << "Il y a #{query.count} listes de tâches :\n\n"
        query.all.each do |task_list|
          message << "• #{task_list.title} (#{task_list.name})\n"
        end
        context.send message
      end

      # Command - Create a task list
      def self.create_list(args, context)
        title = args[2..].join(' ')
        message = context.send title
        ::Tasks.insert(
          name: args[1],
          title: title,
          message_id: message.id,
          tasks: []
        )
        context.message.delete
      end

      # Command - Delete a task list
      def self.delete_list(args, context)
        task_list = find_list(args[1])
        context.channel.message(task_list.message_id).delete
        task_list.delete
        context.message.delete
      end

      # Command - Add a task to a task list
      def self.add_task(args, context)
        task_list = find_list(args[1])
        task_list.tasks << args[2..].join(' ')
        task_list.save
        update_list(context, task_list)
        context.message.delete
      end

      # Command - Remove a task from a task list
      def self.remove_task(args, context)
        task_list = find_list(args[1])
        task_list.tasks.slice!(args[2].to_i-1)
        task_list.save
        update_list(context, task_list)
      end

      # Command - Remove all tasks from a list
      def self.purge_list(args, context)
        task_list = find_list(args[1])
        task_list.tasks = []
        task_list.save
        update_list(context, task_list)
        context.message.delete
      end
    end
  end
end