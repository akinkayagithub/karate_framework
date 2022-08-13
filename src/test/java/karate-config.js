function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'qa';
  }
  var config = {
    env: env,


    base_url: 'https://gorest.co.in',

    create_user_uri: '/public/v2/users',

	tokenID: '6f42ffb9b173ecf6dba4e54148fe80d9bcfa7b46623c65a8ff6317778f068a8c'
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'qa') {
    // customize
  }
  return config;
}