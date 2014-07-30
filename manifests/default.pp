$ssl = true

if $ssl == true {
  $securityprovider = 'ssl'
} else {
  $securityprovider = 'psk'
}

$ssldir = '/var/lib/puppet/ssl'

node 'middleware' inherits 'common' {
  class { '::mcollective':
    middleware       => true,
    middleware_hosts => [ '172.16.0.2' ],
    middleware_ssl     => $ssl,
    securityprovider   => $securityprovider,
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs/',
    #ssl_ca_cert        => "${ssldir}/certs/ca.pem",
    #ssl_server_public  => "${ssldir}/certs/${fqdn}.pem",
    #ssl_server_private => "${ssldir}/private_keys/${fqdn}.pem",
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/mcollective.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/mcollective.pem',
  }
}

node 'server' inherits 'common' {
  class { '::mcollective':
    middleware_hosts => [ '172.16.0.2' ],
    middleware_ssl     => $ssl,
    securityprovider   => $securityprovider,
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs/',
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/mcollective.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/mcollective.pem',
  }
}

node 'client' inherits 'common' {
  class { '::mcollective':
    client           => true,
    middleware_hosts => [ '172.16.0.2' ],
    middleware_ssl     => $ssl,
    securityprovider   => $securityprovider,
    ssl_client_certs   => 'puppet:///modules/site_mcollective/client_certs',
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/mcollective.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/mcollective.pem',
  }
  mcollective::user { 'vagrant':
    certificate => 'puppet:///modules/site_mcollective/client_certs/vagrant.pem',
    private_key => 'puppet:///modules/site_mcollective/private_keys/vagrant.pem',
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

