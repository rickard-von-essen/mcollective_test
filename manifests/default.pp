$ssl = false

node 'middleware' inherits 'common' {
  class { '::mcollective':
    middleware       => true,
    middleware_hosts => [ '172.16.0.2' ],
    middleware_ssl     => $ssl,
    #securityprovider   => 'ssl',
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs',
    ssl_ca_cert        => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/mcollective-servers.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/mcollective-servers.pem',
  }
}

node 'server' inherits 'common' {
  class { '::mcollective':
    middleware_hosts => [ '172.16.0.2' ],
    middleware_ssl     => $ssl,
    #securityprovider   => 'ssl',
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs',
    ssl_ca_cert        => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/mcollective-servers.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/mcollective-servers.pem',
  }
}

node 'client' inherits 'common' {
  class { '::mcollective':
    client           => true,
    middleware_hosts => [ '172.16.0.2' ],
    middleware_ssl     => $ssl,
    #securityprovider   => 'ssl',
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs',
    ssl_ca_cert        => '/var/lib/puppet/ssl/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/mcollective-servers.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/mcollective-servers.pem',
  }
  mcollective::user { 'vagrant':
  #    username    => 'vagrant',
  #    group       => 'vagrant',
  #    homedir     => '/home/vagrant',
  #    certificate => 'puppet:///modules/site_mcollective/client_certs/rivo01.pem',
  #    private_key => 'puppet:///modules/site_mcollective/private_keys/rivo01.pem',
  }
}

node 'common' {
  mcollective::plugin { 'puppet':
    package => true,
  }
  package { 'rubygem-net-ping':
    ensure => installed,
  }
  mcollective::plugin { 'nettest':
    package => true,
    require => Package['rubygem-net-ping'],
  }
  mcollective::plugin { 'package':
    package => true,
  }
  mcollective::plugin { 'service':
    package => true,
  }
}

