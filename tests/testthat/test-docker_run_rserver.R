test_that(".volumes_to_flag has correct output", {
  expect_equal(
    .volumes_to_flag("/test_path/"),
    "-v /test_path/:/test_path/"
  )
  expect_equal(
    .volumes_to_flag("/test_path/", read_only = TRUE),
    "-v /test_path/:/test_path/:ro"
  )
})

test_that("docker_run_rserver has correct output", {
  docker_flags <- docker_run_rserver(return_flags = TRUE)

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
      "dz_bioc",
      "--env USERID=1002 --env GROUPID=1024",
      "bioconductor/bioconductor_docker:RELEASE_3_13"
    )
  )
})
