define tomcat::template(
  $basedir,
  $bind_address,
  $check_port,
  $config,
  $cpu_affinity,
  $dependencies,
  $down,
  $filestore,
  $group,
  $java_home,
  $java_opts,
  $jolokia,
  $jolokia_address,
  $jolokia_port,
  $jolokia_version,
  $localhost,
  $logdir,
  $max_mem,
  $min_mem,
  $mode,
  $product_dir,
  $template,
  $ulimit_nofile,
  $user,
  $version,
  $workspace,
) {
  $filename = $title
  if $filename =~ /^(.*?)\/([^\/]+)$/ {
    $dir = $1
    exec { "create-parent-dir-${product_dir}/${filename}":
      path    => [ '/bin', '/usr/bin' ],
      command => "mkdir -p ${product_dir}/${dir}",
      creates => "${product_dir}/${dir}",
      user    => $user,
      group   => $group,
      require => Exec["tomcat-unpack-${user}"],
    }
  }
  file { "${product_dir}/${filename}":
    owner    => $user,
    group    => $group,
    mode     => $mode,
    content  => template($template),
    require  => Exec[
      "tomcat-unpack-${user}",
      "create-parent-dir-${product_dir}/${filename}"
    ],
  }
}
