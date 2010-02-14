require 'rubygems'
require 'spec'

require "git_r_backup"


describe GitRBackup do
    
    
  def std_args
    {
      :base => '.',
      :cache => 'tmp/backup_cache'
    }
  end
  
  def db_args
    std_args.merge({ :app => '.' })
  end
  
  def assets_args
    std_args.merge({ :assets => 'public/assets' })
  end
  
  
  describe "initialization" do
    
    describe "correctly required init options" do
      
      it "should complain on no args" do
        lambda {
          GitRBackup.new({})
        }.should raise_error
      end
      
      it "should not complain with standard args" do
        lambda {
          GitRBackup.new(std_args)
        }.should_not raise_error
      end
      
      it "should complain on missing :base arg" do
        lambda {
          GitRBackup.new(std_args.except(:base))
        }.should raise_error
      end
      
      it "should complain on missing :cache arg" do
        lambda {
          GitRBackup.new(std_args.except(:cache))
        }.should raise_error
      end
      
    end # "correctly required init options"
    
    
    describe "correctly inited instance variables" do
      
      it "backup_cache_repo_dir" do
        grb = GitRBackup.new std_args
        grb.instance_variable_get(:@backup_cache_repo_dir).should == './tmp/backup_cache'
      end
      
      it "backup_cache_sub_dir" do
        grb = GitRBackup.new std_args
        grb.instance_variable_get(:@backup_cache_sub_dir).should be_nil
        
        grb = GitRBackup.new std_args.merge({:sub => 'servername.appinstance.environment'})
        # assuming @backup_cache_repo_dir == './tmp/backup_cache'
        grb.instance_variable_get(:@backup_cache_sub_dir).should == './tmp/backup_cache/servername.appinstance.environment'
      end
      
      it "app_dir" do
        grb = GitRBackup.new std_args
        grb.instance_variable_get(:@app_dir).should be_nil
        
        grb = GitRBackup.new db_args
        ['.', './.'].should be_include(grb.instance_variable_get(:@app_dir))
      end
      
      it "app_db_data_dump_path" do
        grb = GitRBackup.new std_args
        grb.instance_variable_get(:@app_db_data_dump_path).should be_nil
        
        grb = GitRBackup.new db_args
        # assuming @app_dir is '.' or './.'
        ['./db/data.yml', '././db/data.yml'].should be_include(grb.instance_variable_get(:@app_db_data_dump_path))
      end
      
      it "app_db_schema_dump_path" do
        grb = GitRBackup.new std_args
        grb.instance_variable_get(:@app_db_schema_dump_path).should be_nil
        
        grb = GitRBackup.new db_args
        # assuming @app_dir is '.' or './.'
        ['./db/schema.rb', '././db/schema.rb'].should be_include(grb.instance_variable_get(:@app_db_schema_dump_path))
      end
      
      it "assets_dir" do
        grb = GitRBackup.new std_args
        grb.instance_variable_get(:@assets_dir).should be_nil
        
        grb = GitRBackup.new assets_args
        grb.instance_variable_get(:@assets_dir).should == './public/assets'
      end
      
    end # "correctly inited instance variables"
    
  end # "initialization"
  
  
  describe "git operations" do
    before(:all) do
      FileUtils.mkdir_p('tmp')
      
      FileUtils.mkdir_p @assets_dir = File.join('tmp', 'assets')
      FileUtils.touch File.join(@assets_dir, 'test')
    end
    
    
    describe "without git repo" do
      before(:all) { @git_repo_dir = 'tmp/spec_fresh_repo' }
      
      before(:each) do
        FileUtils.rm_r(@git_repo_dir) if File.exists?(@git_repo_dir)
      end
      
      it "should having working 'git_repo()'" do
        grb = GitRBackup.new std_args.merge({:cache => @git_repo_dir})
        grb.send :git_repo
      end
      
      it "should having working 'backup_db()'" do
        pending # not sure how to get at yaml_db from here; may have to stub it out
        
        grb = GitRBackup.new db_args.merge({:cache => @git_repo_dir})
        grb.backup_db
      end
      
      it "should having working 'backup_assets()'" do
        grb = GitRBackup.new assets_args.merge({:cache => @git_repo_dir, :assets => @assets_dir})
        
        lambda {
          grb.backup_assets
        }.should raise_error Errno::ENOENT
      end
    end
    
    describe "with a stand-alone git repo" do
      before(:all) { @git_repo_dir = 'tmp/spec_standalone_repo' }
      
      before(:each) do
        FileUtils.rm_r(@git_repo_dir) if File.exists?(@git_repo_dir)
        FileUtils.mkdir_p(@git_repo_dir)
        Git.init File.expand_path(@git_repo_dir)
      end
      
      it "should having working 'git_repo()'" do
        grb = GitRBackup.new std_args.merge({:cache => @git_repo_dir})
        grb.send :git_repo
      end
      
      it "should having working 'backup_db()'" do
        pending # not sure how to get at yaml_db from here; may have to stub it out
        
        grb = GitRBackup.new db_args.merge({:cache => @git_repo_dir})
        grb.backup_db
      end
      
      it "should having working 'backup_assets()'" do
        grb = GitRBackup.new assets_args.merge({:cache => @git_repo_dir, :assets => @assets_dir})
        grb.backup_assets
      end
    end
    
    describe "with a remotely-cloned git repo" do
      before(:all) { @git_orig_repo_dir = 'tmp/spec_remote_repo'; @git_repo_dir = 'tmp/spec_cloned_repo' }
      
      before(:each) do
        FileUtils.rm_r(@git_orig_repo_dir) if File.exists?(@git_orig_repo_dir)
        FileUtils.mkdir_p(@git_orig_repo_dir)
        Git.init File.expand_path(@git_orig_repo_dir)
        
        FileUtils.rm_r(@git_repo_dir) if File.exists?(@git_repo_dir)
        FileUtils.mkdir_p(@git_repo_dir)
        Git.clone File.expand_path(@git_orig_repo_dir), File.expand_path(@git_repo_dir)
      end
      
      it "should having working 'git_repo()'" do
        grb = GitRBackup.new std_args.merge({:cache => @git_repo_dir})
        grb.send :git_repo
      end
      
      it "should having working 'backup_db()'" do
        pending # not sure how to get at yaml_db from here; may have to stub it out
        
        grb = GitRBackup.new db_args.merge({:cache => @git_repo_dir})
        grb.backup_db
      end
      
      it "should having working 'backup_assets()'" do
        grb = GitRBackup.new assets_args.merge({:cache => @git_repo_dir, :assets => @assets_dir})
        grb.backup_assets
      end
    end
    
  end # "git operations"
  
  
end
