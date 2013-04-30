dirtree
=======

*This module provides the `dirtree` function.*

The `dirtree` function accepts a string containing an absolute directory path
and will return an array of the tree containing all the folders of that path.

Best efforts have been made to make this function compatible with both Windows and Linux systems.

Examples
--------

    dirtree('/usr/share/puppet')
    Will return: ['/usr', '/usr/share', '/usr/share/puppet']

    dirtree('C:\\windows\\system32\\')
    Will return: ["C:\\windows", "C:\\windows\\system32"]

You can use the `dirtree` function in a class to enumerate all required directories if needed.

    class { 'dirtree_example':
      # Puppet[:vardir] = /var/lib/puppet
      $dirtree = dirtree(Puppet[:vardir])

      # $dirtree = ['/var', '/var/lib', '/var/lib/puppet']
      file { $dirtree:
        ensure => present,
      }
    }


Support
-------

Please file tickets and issues using [GitHub Issues](https://github.com/AlexCline/dirtree/issues)


License
-------
   Copyright 2013 Alex Cline <alex.cline@gmail.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

