%w[
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
  app/libs
].each { |path| Spring.watch(path) }
