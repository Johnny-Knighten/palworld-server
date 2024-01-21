## [1.0.1-next.1](https://github.com/Johnny-Knighten/palworld-server/compare/1.0.0...1.0.1-next.1) (2024-01-21)


### Bug Fixes

* added badges to readme ([a6f9449](https://github.com/Johnny-Knighten/palworld-server/commit/a6f94496b029069ebf9365334bdd3c5bf24e2a2a))

## [1.0.0](https://github.com/Johnny-Knighten/palworld-server/compare/...1.0.0) (2024-01-21)


### Bug Fixes

* changed container PGID and PUID default to 1000 ([cf335a6](https://github.com/Johnny-Knighten/palworld-server/commit/cf335a63cb102a76702fdccd8cdea23c64ce04e4))
* changed default port in palworld-server test ([ac9c40a](https://github.com/Johnny-Knighten/palworld-server/commit/ac9c40a421a8e36f97a3b0243ee6513e33c4de84))
* correct name of boostrap supervisor process ([2a6c95d](https://github.com/Johnny-Knighten/palworld-server/commit/2a6c95d86f62a676acfc41aa6ab7ff37035a699a))
* corrected logic for creating PalWorldSetting.ini if it doesn't exist ([b083272](https://github.com/Johnny-Knighten/palworld-server/commit/b08327234afb2e6531c5bdabd5f1b794907d4489))
* corrected wrong file path ([e66187c](https://github.com/Johnny-Knighten/palworld-server/commit/e66187c10aa6140f4f40b9a5b0f3a3ccb6812d32))
* linted python files to pass ([65dd1bc](https://github.com/Johnny-Knighten/palworld-server/commit/65dd1bc2d4ae5ae5e344ba0165ba8f08cc3c31a6))
* removed __pycache__ from repo and added ignore to prevent it ([2f6fa6a](https://github.com/Johnny-Knighten/palworld-server/commit/2f6fa6a32f871314b045c08729d5a93a66fb0f10))
* removed tzdata test and updated steamcmd path ([c1be8d6](https://github.com/Johnny-Knighten/palworld-server/commit/c1be8d6eb18bc96bbf6a5f8d73de967be25f2258))
* version locked dependencies in Dockerfile ([f334b5f](https://github.com/Johnny-Knighten/palworld-server/commit/f334b5f23762fad10ca149265eed7fae8ac11931))


### Features

* added build and test gha ([a0b6863](https://github.com/Johnny-Knighten/palworld-server/commit/a0b6863794f63ee400100e4866c912792ff10e0c))
* added config_from_env_vars but have not yet integrated ([334dbe6](https://github.com/Johnny-Knighten/palworld-server/commit/334dbe60fb66612c794479b504196e65f08f4dab))
* added core test suite ([b446917](https://github.com/Johnny-Knighten/palworld-server/commit/b4469173c7323556833016c480a44e0f99af2e96))
* added palworl-server.sh which is responsible for server start and cleanup ([bfc8927](https://github.com/Johnny-Knighten/palworld-server/commit/bfc892777e9aa44c892b978ea580ff4b046970f4))
* added repo license ([a68c05e](https://github.com/Johnny-Knighten/palworld-server/commit/a68c05e80b6a9f559bda7c7aee8f7f60ee81a54e))
* added semver gha ([e3d79b8](https://github.com/Johnny-Knighten/palworld-server/commit/e3d79b8aee445a7d203267e8a6f5fe0dc9197468))
* barbones Dockerfile and entry script to start install ([46dbaf1](https://github.com/Johnny-Knighten/palworld-server/commit/46dbaf1c4740cf225065ec1ef8f5ed02eb405fc2))
* flushed out the ability to configure PalWorldSettings.ini via PALWORLD_ env vars ([9592e53](https://github.com/Johnny-Knighten/palworld-server/commit/9592e537dd98b486a45b6c9403ba696ffc2812bc))
* implemented backup service and backup on stop ([01d0799](https://github.com/Johnny-Knighten/palworld-server/commit/01d0799fd365a44e30997a01abc729f48198d037))
* implemented cron based update, restart, and backup ([dff2c5b](https://github.com/Johnny-Knighten/palworld-server/commit/dff2c5be4957250611259b5ccf0e0f1817153f92))
* implemented env variables that cover officially documented command args for server executable ([bab9444](https://github.com/Johnny-Knighten/palworld-server/commit/bab94445865012533398c10a53b02b599725bf9c))
* init commit ([37d8223](https://github.com/Johnny-Knighten/palworld-server/commit/37d8223cebed61c62cf74e265de9409ebe802126))
* installed cron into container ([95924ee](https://github.com/Johnny-Knighten/palworld-server/commit/95924eeec83f3639cf7bcd65435ac21f48938773))
* introduced supervisord and added a boostrap entry point ([1903b8a](https://github.com/Johnny-Knighten/palworld-server/commit/1903b8a373996177d3dfebe1ee47376b040a7308))

## [1.0.0-next.2](https://github.com/Johnny-Knighten/palworld-server/compare/1.0.0-next.1...1.0.0-next.2) (2024-01-21)


### Bug Fixes

* changed default port in palworld-server test ([ac9c40a](https://github.com/Johnny-Knighten/palworld-server/commit/ac9c40a421a8e36f97a3b0243ee6513e33c4de84))
* removed tzdata test and updated steamcmd path ([c1be8d6](https://github.com/Johnny-Knighten/palworld-server/commit/c1be8d6eb18bc96bbf6a5f8d73de967be25f2258))
* version locked dependencies in Dockerfile ([f334b5f](https://github.com/Johnny-Knighten/palworld-server/commit/f334b5f23762fad10ca149265eed7fae8ac11931))


### Features

* added core test suite ([b446917](https://github.com/Johnny-Knighten/palworld-server/commit/b4469173c7323556833016c480a44e0f99af2e96))

## [1.0.0-next.1](https://github.com/Johnny-Knighten/palworld-server/compare/...1.0.0-next.1) (2024-01-21)


### Bug Fixes

* changed container PGID and PUID default to 1000 ([cf335a6](https://github.com/Johnny-Knighten/palworld-server/commit/cf335a63cb102a76702fdccd8cdea23c64ce04e4))
* correct name of boostrap supervisor process ([2a6c95d](https://github.com/Johnny-Knighten/palworld-server/commit/2a6c95d86f62a676acfc41aa6ab7ff37035a699a))
* corrected logic for creating PalWorldSetting.ini if it doesn't exist ([b083272](https://github.com/Johnny-Knighten/palworld-server/commit/b08327234afb2e6531c5bdabd5f1b794907d4489))
* corrected wrong file path ([e66187c](https://github.com/Johnny-Knighten/palworld-server/commit/e66187c10aa6140f4f40b9a5b0f3a3ccb6812d32))
* linted python files to pass ([65dd1bc](https://github.com/Johnny-Knighten/palworld-server/commit/65dd1bc2d4ae5ae5e344ba0165ba8f08cc3c31a6))
* removed __pycache__ from repo and added ignore to prevent it ([2f6fa6a](https://github.com/Johnny-Knighten/palworld-server/commit/2f6fa6a32f871314b045c08729d5a93a66fb0f10))


### Features

* added build and test gha ([a0b6863](https://github.com/Johnny-Knighten/palworld-server/commit/a0b6863794f63ee400100e4866c912792ff10e0c))
* added config_from_env_vars but have not yet integrated ([334dbe6](https://github.com/Johnny-Knighten/palworld-server/commit/334dbe60fb66612c794479b504196e65f08f4dab))
* added palworl-server.sh which is responsible for server start and cleanup ([bfc8927](https://github.com/Johnny-Knighten/palworld-server/commit/bfc892777e9aa44c892b978ea580ff4b046970f4))
* added repo license ([a68c05e](https://github.com/Johnny-Knighten/palworld-server/commit/a68c05e80b6a9f559bda7c7aee8f7f60ee81a54e))
* added semver gha ([e3d79b8](https://github.com/Johnny-Knighten/palworld-server/commit/e3d79b8aee445a7d203267e8a6f5fe0dc9197468))
* barbones Dockerfile and entry script to start install ([46dbaf1](https://github.com/Johnny-Knighten/palworld-server/commit/46dbaf1c4740cf225065ec1ef8f5ed02eb405fc2))
* flushed out the ability to configure PalWorldSettings.ini via PALWORLD_ env vars ([9592e53](https://github.com/Johnny-Knighten/palworld-server/commit/9592e537dd98b486a45b6c9403ba696ffc2812bc))
* implemented backup service and backup on stop ([01d0799](https://github.com/Johnny-Knighten/palworld-server/commit/01d0799fd365a44e30997a01abc729f48198d037))
* implemented cron based update, restart, and backup ([dff2c5b](https://github.com/Johnny-Knighten/palworld-server/commit/dff2c5be4957250611259b5ccf0e0f1817153f92))
* implemented env variables that cover officially documented command args for server executable ([bab9444](https://github.com/Johnny-Knighten/palworld-server/commit/bab94445865012533398c10a53b02b599725bf9c))
* init commit ([37d8223](https://github.com/Johnny-Knighten/palworld-server/commit/37d8223cebed61c62cf74e265de9409ebe802126))
* installed cron into container ([95924ee](https://github.com/Johnny-Knighten/palworld-server/commit/95924eeec83f3639cf7bcd65435ac21f48938773))
* introduced supervisord and added a boostrap entry point ([1903b8a](https://github.com/Johnny-Knighten/palworld-server/commit/1903b8a373996177d3dfebe1ee47376b040a7308))
