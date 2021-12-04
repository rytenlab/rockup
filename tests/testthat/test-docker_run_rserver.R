test_that(".volumes_to_flag has correct output", {
  expect_equal(
    .volumes_to_flag("/test_path/"),
    "-v /test_path/:/test_path/"
  )
  expect_equal(
    .volumes_to_flag("/test_path/", read_only = TRUE),
    "-v /test_path/:/test_path/:ro"
  )
  # also works if users input /host_path/:/cont_path/ format
  expect_equal(
    .volumes_to_flag("/host_path/:/cont_path/"),
    "-v /host_path/:/cont_path/"
  )
  expect_equal(
    .volumes_to_flag("/host_path/:/cont_path/", read_only = TRUE),
    "-v /host_path/:/cont_path/:ro"
  )
})

test_that("docker_run_rserver has correct output", {
  # defaults, only image set
  docker_flags <- docker_run_rserver(
    image = "docker_image",
    port = 8888,
    return_flags = TRUE
  )

  expect_type(docker_flags, "character")

  expect_equal(
    docker_flags,
    c(
      "run",
      "--env",
      "PASSWORD=bioc",
      "--publish",
      "8888:8787",
      "--detach",
      "--name",
      "rockup_container",
      "docker_image"
    )
  )

  # also with args set
  # including volume and USERID/GROUPID args
  docker_flags <- docker_run_rserver(
    image = "docker_image",
    port = 9999,
    name = "cont_name",
    detach = FALSE,
    volumes = "a_volume",
    volumes_ro = "another_volume",
    permissions = "match",
    USERID = 1000,
    GROUPID = 1000,
    return_flags = TRUE
  )

  expect_equal(
    docker_flags,
    c(
      "run",
      "--env",
      "PASSWORD=bioc",
      "--publish",
      "9999:8787",
      "--name",
      "cont_name",
      "--env USERID=1000 --env GROUPID=1000",
      "-v a_volume:a_volume",
      "-v another_volume:another_volume:ro",
      "docker_image"
    )
  )
})

test_that("docker_run_rserver catches user-input errors", {
  expect_error(
    docker_flags <- docker_run_rserver(port = 8888, return_flags = TRUE),
    'argument "image" is missing, with no default'
  )
  expect_error(
    docker_flags <- docker_run_rserver(return_flags = TRUE),
    'argument "port" is missing, with no default'
  )
  expect_error(
    docker_flags <- docker_run_rserver(port = 8888, permissions = "match"),
    "USERID and GROUPID must be non-NULL, if permissions set to 'match'"
  )
  expect_error(
    docker_flags <- docker_run_rserver(
      port = 8888,
      permissions = "match",
      USERID = 1000
    ),
    "USERID and GROUPID must be non-NULL, if permissions set to 'match'"
  )
  expect_error(
    docker_flags <- docker_run_rserver(
      port = 8888,
      permissions = "match",
      GROUPID = 1000
    ),
    "USERID and GROUPID must be non-NULL, if permissions set to 'match'"
  )
  expect_error(
    docker_flags <- docker_run_rserver(
      port = 8888,
      permissions = "something",
      USERID = 1000,
      GROUPID = 1000
    ),
    "permissions must be 'match' or NULL"
  )
})
