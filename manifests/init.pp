class java {
  $jre_url = 'https://s3.amazonaws.com/boxen-downloads/java/jre-7u21-macosx-x64.dmg'
  $jdk_url = 'https://s3.amazonaws.com/boxen-downloads/java/jdk-7u21-macosx-x64.dmg'
  $wrapper = "${boxen::config::bindir}/java"

  # Allow 'large' keys locally.
#  $java_home = "#{`/usr/libexec/java_home`}"
#  $sec_dir = "#{java_home}/lib/security"

  $sec_dir = "foo"

  # !! TODO !! put in s3
  $local_policy_url = 'http://cl.ly/1I3t1K1Q0G1N/download/local_policy.jar'
  $local_policy_path = "#{sec_dir}/local_policy.jar"

  # !! TODO !! put in s3
  $us_policy_url = 'http://cl.ly/2M0s2l3v1x2m/download/US_export_policy.jar'
  $us_policy_path = "#{sec_dir}/US_policy.jar"

  package {
    'jre-7u21.dmg':
      ensure   => present,
      alias    => 'java-jre',
      provider => pkgdmg,
      source   => $jre_url ;
    'jdk-7u21.dmg':
      ensure   => present,
      alias    => 'java',
      provider => pkgdmg,
      source   => $jdk_url ;
  }

  file { $wrapper:
    source  => 'puppet:///modules/java/java.sh',
    mode    => 0755,
    require => Package['java']
  }

  file { "#{`/usr/libexec/java_home`}/lib/security":
    ensure  => 'directory',
    owner   => 'root',
    mode    => 0775,
    alias   => 'sec-dir',
    require => Package['java']
  }

  file { $local_policy_path:
    source  => $local_policy_url,
    owner   => 'root',
    mode    => 0664,
    require => File['sec-dir']
  }

  file { $local_policy_path:
    source  => $local_policy_url,
    owner   => 'root',
    mode    => 0664,
    require => File['sec-dir']
  }
}
