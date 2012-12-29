require 'fileutils'
require 'open3'

module CommandLineHelpers

  extend self

  Invocation = Struct.new :stdout, :stderr, :status do
    def exitstatus
      status.exitstatus
    end
  end

  def proving_grounds_dir
    "tmp/proving_grounds"
  end

  def config_filename
    ".i_like_mustaches"
  end

  def mustache_filename
    "mustache_file"
  end

  def path_to_lib
    dir = Dir.pwd
    until Dir.glob("#{dir}/*").map(&File.method(:basename)).include?("lib")
      dir = File.expand_path File.dirname dir
    end
    File.join dir, "lib"
  end

  def make_proving_grounds
    FileUtils.mkdir_p proving_grounds_dir
  end

  def set_proving_grounds_as_home
    ENV['HOME'] = File.expand_path proving_grounds_dir
  end

  def in_proving_grounds(&block)
    Dir.chdir proving_grounds_dir, &block
  end

  def kill_config_file
    in_proving_grounds { FileUtils.rm_f config_filename }
  end

  def kill_mustache_file
    in_proving_grounds { FileUtils.rm_f mustache_filename }
  end

  def set_config_file(body)
    in_proving_grounds do
      File.open(config_filename, 'w') { |file| file.puts body }
    end
  end

  def set_mustache_file(body)
    in_proving_grounds do
      File.open(mustache_filename, 'w') { |file| file.puts body }
    end
  end

  def invoke_mustache_file_with(args)
    in_proving_grounds do
      command = "ruby -I #{path_to_lib} #{mustache_filename} #{args}"
      Invocation.new *Open3.capture3(command)
    end
  end
end
