class votocomovamos::app {

  rbenv::install {
    'vagrant':
      home => '/home/vagrant'
    ;
  }

  rbenv::compile {
    '1.9.3-p385':
      user   => 'vagrant',
      home   => '/home/vagrant',
      global => true,
    ;
  }

  $passenger_version = '3.0.19'
  $gem_path = '/opt/vagrant_ruby/lib/ruby/gems/1.8/gems'


  class {
    'apache':
    ;

    'passenger':
      passenger_package      => 'passenger',
      passenger_version      => $passenger_version,
      passenger_ruby         => '/home/vagrant/.rbenv/shims/ruby',
      gem_path               => $gem_path,
      gem_binary_path        => '/opt/vagrant_ruby/bin',
      mod_passenger_location => "${gem_path}/passenger-${passenger_version}/ext/apache2/mod_passenger.so",
      require                => Bundler::Install['/vagrant'],
    ;
  }

  apache::vhost {
    'vcv':
      vhost_name    => '*',
      port          => '80',
      template      => 'apache/vhost-passenger.conf.erb',
      serveradmin   => 'vcv@lixo.org',
      docroot       => '/vagrant/public',
      docroot_owner => 'vagrant',
      docroot_group => 'vagrant',
    ;
  }

  bundler::install {
    '/vagrant':
      gem_bin_path => '/home/vagrant/.rbenv/shims',
      user         => 'vagrant',
      group        => 'vagrant',
      require      => Rbenv::Gem['rbenv::bundler vagrant 1.9.3-p385'],
    ;
  }

}

