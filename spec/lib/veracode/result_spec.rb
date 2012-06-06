require (File.expand_path('./../../../spec_helper', __FILE__))

describe Veracode::Results do
  describe "GET profile" do

    let(:veracode) { Veracode::Results.new(:username => "test", :password => "test") }

    before do
      VCR.insert_cassette 'base', :record => :new_episodes
    end

    after do
      VCR.eject_cassette
    end

    it "must have a get_application_builds method" do
      veracode.must_respond_to :get_application_builds
    end

    it "must have a get_application_builds method" do
      veracode.must_respond_to :get_detailed_report
    end

    it "must parse the api response from XML to Veracode::Result::Builds::Applications" do
      veracode.get_application_builds.must_be_instance_of Veracode::Result::Builds::Applications
    end

    it "must parse the api response from XML to Veracode::Result::DetailedReport" do
      veracode.get_detailed_report("44905").must_be_instance_of Veracode::Result::DetailedReport
    end
    
    describe "dynamic attributes for builds" do

      before do
        @builds = veracode.get_application_builds
      end

      it "must raise method missing if attribute is not present" do
        lambda { @builds.foo_attribute }.must_raise NoMethodError
      end
    end
    
    describe "dynamic attributes for results" do

      before do
        @result = veracode.get_detailed_report("44905")
      end
      
      it "must return the attribute value if present" do
        @result.app_name.must_equal "WebGoat"
      end
      
      it "must be an instance of Veracode::Result::Analysis" do
        @result.static_analysis.must_be_instance_of Veracode::Result::Analysis
      end
      
      it "must be an instance of Veracode::Result::Analysis" do
        @result.dynamic_analysis.must_be_instance_of Veracode::Result::Analysis
      end
      
      it "must be an instance of Veracode::Result::ManualAnalysis" do
        @result.manual_analysis.must_be_instance_of Veracode::Result::ManualAnalysis
      end

      it "must raise method missing if attribute is not present" do
        lambda { @result.foo_attribute }.must_raise NoMethodError
      end
    end
  end
end
