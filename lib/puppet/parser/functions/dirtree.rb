#
# dirtree.rb
#

module Puppet::Parser::Functions
  newfunction(:dirtree, :type => :rvalue, :doc => <<-EOS
This function accepts a string containing an absolute directory path
and will return an array of the tree containing all the folders of that path.

*Examples:*

    dirtree('/usr/share/puppet')
    Will return: ['/usr', '/usr/share', '/usr/share/puppet']

    dirtree('C:\\windows\\system32\\')
    Will return: ["C:\\windows", "C:\\windows\\system32"]
    EOS
  ) do |arguments|
    path = arguments[0]

    unless path.is_a?(String)
      raise Puppet::ParseError, "dirtree(): expected first argument to be a String, got #{path.inspect}"
    end

    is_posix = Puppet::Util.absolute_path?(path, :posix)
    is_windows = Puppet::Util.absolute_path?(path, :windows)

    unless is_posix or is_windows
      raise Puppet::ParseError, "dirtree(): #{path.inspect} is not an absolute path."
    end

    sep = is_posix ? '/' : '\\'
    result = []

    # If the last character is the separator, chop it off!
    path[-1, 1] == sep ? path.chop! : nil

    # Start trimming and pushing to the new array
    while ( path != '' and is_posix ) or ( path.length > 2 and is_windows )
      result.unshift(path)
      path = path[0..path.rindex(sep)].chop
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
