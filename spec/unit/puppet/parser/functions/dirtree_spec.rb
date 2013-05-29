#! /usr/bin/env ruby -S rspec
require 'spec_helper'

describe "the dirtree function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("dirtree").should == "function_dirtree"
  end

  it "should raise a ParseError if the first argument is not a String" do
    lambda { scope.function_dirtree([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the first argument is not an absolute path" do
    lambda { scope.function_dirtree(['usr/share/puppet'])}.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if the second argument is not a String" do
    lambda { scope.function_dirtree([]) }.should( raise_error(Puppet::ParseError) )
  end

  it "should raise a ParseError if the second argument is not an absolute path" do
    lambda { scope.function_dirtree([]) }.should( raise_error(Puppet::ParseError) )
  end

  it "should return an array of the posix directory tree" do
    result = scope.function_dirtree(['/usr/share/puppet'])
    result.should(eq(['/usr', '/usr/share', '/usr/share/puppet']))
  end

  it "should return an array of the windows directory tree" do
    result = scope.function_dirtree(['C:\\windows\\system32\\'])
    result.should(eq(["C:\\windows", "C:\\windows\\system32"]))
  end

  it "should return an array of the posix directory tree without the first directory" do
    result = scope.function_dirtree(['/usr/share/puppet', '/usr'])
    result.should(eq(['/usr/share', '/usr/share/puppet']))
  end

  it "should return an array of the windows directory tree without the first directory" do
    result = scope.function_dirtree(['C:\\windows\\system32\\drivers\\', 'C:\\windows'])
    result.should(eq(["C:\\windows\\system32", "C:\\windows\\system32\\drivers"]))
  end

  it "should return the array without the first directory if there's a trailing slash on the exclude" do
    result = scope.function_dirtree(['/var/lib/puppet/ssl', '/var/lib/'])
    result.should(eq(['/var/lib/puppet', '/var/lib/puppet/ssl']))
  end

end
