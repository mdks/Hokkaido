require "Hokkaido/version"
require 'gem_modifier'
require 'term/ansicolor'

module Hokkaido

  RUBYMOTION_GEM_CONFIG = <<-HEREDOC
  Motion::Project::App.setup do |app|
    MAIN_CONFIG_FILES
  end
  HEREDOC

  INCLUDE_STRING = "    app.files << File.expand_path(File.join(File.dirname(__FILE__),'RELATIVE_LIBRARY_PATH'))"

  class Port

    def initialize(info, options=nil)
      @mod_gem = GemModifier.new(info)
    end

    def modify
      @mod_gem.modify!
    end

    def test
      true_path = File.join(@mod_gem.lib_folder, @mod_gem.init_lib)
      mocklib = File.expand_path('lib/motion_mock.rb')
      system("/usr/bin/env ruby -r #{mocklib} #{true_path}")
    end
  end

  def self.self_test_result(port)
    if port.test
      puts "The #require removal was successful.".colorize(:green)
    else
      puts "The #require removal has failed.".colorize(:red)
    end
  end

  def self.valid_input?(args)
    if args.length == 3 && args[0].length > 0
      name, init_filename, lib_dir = args
      init_path = File.join(lib_dir, init_filename)
      File.directory?(lib_dir) && File.exists?(init_path)
    end
  end
end
