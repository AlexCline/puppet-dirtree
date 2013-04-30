#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dirtree function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dirtree").should == "function_dirtree"
  end

  it "should raise a ParseError if the supplied argument is not a String" do
    lambda { scope.function_dirtree([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the supplied argument is not an absolute path" do
    lambda { scope.function_dirtree(['usr/share/puppet'])}.should( raise_error(Puppet::ParseError))
  end

  it "should return an array of the posix directory tree" do
    result = scope.function_dirtree(['/usr/share/puppet'])
    result.should(eq(['/usr', '/usr/share', '/usr/share/puppet']))
  end

  it "should return an array of the windows directory tree" do
    result = scope.function_dirtree(['C:\\windows\\system32\\'])
    result.should(eq(["C:\\windows", "C:\\windows\\system32"]))
  end
end
