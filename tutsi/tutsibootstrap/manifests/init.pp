class tutsibootstrap {

	Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
	$required_packages = ['puppet', 'git', 'librarian-puppet', 'python-software-properties']

	exec {'apt-get-update':
		command => "apt-get update"
	}

/*	exec {'apt-get-upgrade':
		command => "apt-get upgrade -y"
	}*/

	file {'Puppetfile-copy':
		path => '/vagrant/Puppetfile', 
		source => '/vagrant/files/Puppetfile',
	}

	exec {'Puppetfile-remove':
		command => 'rm -f /vagrant/Puppetfile', 
		onlyif => 'cmp -s /vagrant/files/Puppetfile Puppetfile'
	}
	
	package { $required_packages:
		ensure => latest,
	}

	exec {'librarian-puppet-install':
		cwd => '/vagrant',
		command => "librarian-puppet install",

	}

	exec {'librarian-puppet-init':
		cwd => '/vagrant',
		command => "librarian-puppet init",
		require => Exec['Puppetfile-remove'],
		unless =>  "test -f /vagrant/Puppetfile"
	}


Exec['apt-get-update'] -> 
Package[$required_packages] ->
Exec['librarian-puppet-init'] ->
File['Puppetfile-copy'] ->
Exec['librarian-puppet-install']
}