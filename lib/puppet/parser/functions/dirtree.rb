#
# dirtree.rb
#

module Puppet::Parser::Functions
  newfunction(:dirtree, :type => :rvalue, :doc => <<-EOS
This function accepts a string containing an absolute directory path
and will return an array of the tree containing all the folders of that path.

An optional second parameter can be supplied that contains a path to exclude
from the resulting array.

*Examples:*

    dirtree('/usr/share/puppet')
    Will return: ['/usr', '/usr/share', '/usr/share/puppet']

    dirtree('C:\\windows\\system32\\drivers')
    Will return: ["C:\\windows", "C:\\windows\\system32", "C:\\windows\\system32\\drivers"]

    dirtree('/usr/share/puppet', '/usr')
    Will return: ['/usr/share', '/usr/share/puppet']

    dirtree('C:\\windows\\system32\\drivers', 'C:\\windows')
    Will return: ['C:\\windows\\system32', 'C:\\windows\\system32\\drivers']
    EOS
  ) do |arguments|
    path = arguments[0]
    exclude = arguments[1] || '/'

    unless path.is_a?(String)
      raise Puppet::ParseError, "dirtree(): expected first argument to be a String, got #{path.inspect}"
    end

    unless exclude.is_a?(String)
      raise Puppet::ParseError, "dirtree(): expected second argument to be a String, go #{exclude.inspect}"
    end

    is_posix = Puppet::Util.absolute_path?(path, :posix)
    is_windows = Puppet::Util.absolute_path?(path, :windows)

    unless is_posix or is_windows
      raise Puppet::ParseError, "dirtree(): #{path.inspect} is not an absolute path."
    end

    ex_posix = Puppet::Util.absolute_path?(exclude, :posix)
    ex_windows = Puppet::Util.absolute_path?(exclude, :windows)

    unless ex_posix or ex_windows
      raise Puppet::ParseError, "dirtree(): #{exclude.inspect} is not an absolute path."
    end

    sep = is_posix ? '/' : '\\'
    result = []

    # If the last character is the separator, discard it
    path[-1, 1] == sep ? path.chop! : nil
    exclude[-1, 1] == sep ? exclude.chop! : nil

    # Start trimming and pushing to the new array
    # If the path is a posix path, the string will be empty when done parsing
    # If the path is a windows path, the string will have the drive letter and a colon when done parsing.
    while ( path != '' and is_posix ) or ( path.length > 2 and is_windows ) and ( path != exclude )
      result.unshift(path)
      path = path[0..path.rindex(sep)].chop
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
