#' Run an R Studio server instance on rocker-based image
#'
#' A wrapper for the docker function used to run a R Studio server process on a
#' specified docker image. The docker image must be based on
#' [rocker](https://github.com/rocker-org/rocker). This will be available at the
#' `port` specified on the host. Currently, the `permissions` argument operates
#' through setting a `USERID` and `GROUPID`, which are by default set to my
#' user's settings. The `USERID` and `GROUPID` of the current user can be
#' checked using the `id` bash command. In order to make sure your volumes have
#' the correct permissions, these settings should be modified to match the user
#' of interest.
#'
#' @param image `character(1)` name of the image to use
#' @param port `integer(1)` port of the host which will be used to access
#'   RStudio server via `localhost::port`.
#' @param password `character(1)` password to used for RStudio server.
#' @param name `character(1)` name for the container.
#' @param detach `logical(1)` whether to use the `-d` flag when running the
#'   container. Should the container continue to run in the background after
#'   `docker run` has executed?
#' @param rm `logical(1)` whether to use the `-rm` flag when running the
#'   container. Should the container be removed when stopped?
#' @param volumes `character(1)` paths for the hosts files that you want
#'   accessible in the container. See argument `permissions` for read/write
#'   access to these. Can either be a path on host or in the form
#'   "host_path:container_path".
#' @param volumes_ro `character(1)` paths for the hosts files that you want
#'   accessible in the container. These will be read-only on the container and
#'   this option is recommended for any volumes you don't need to modify.
#' @param permissions `character(1)` if set to "match" (be careful!), then the
#'   permissions of the mounted volumes on the container, will match that of the
#'   host. I.e. the user executing the docker command will have permissions to
#'   read/write/execute in the container as they did on the host.
#' @param USERID `integer(1)` the USERID of the user for which you would like
#'   the permissions of the mounted volumes to match.
#' @param GROUPID `integer(1)` the GROUPID of the user for which you would like
#'   the permissions of the mounted volumes to match.
#' @param verbose `logical(1)` whether to display the command to be run (for
#'   debugging purposes).
#' @param return_flags `logical(1)` whether to return the flags to be inputted
#'   into `docker run`. Used for testing and example.
#'
#' @return NULL
#' @export
#'
#' @references `docker_run_rserver` is based on
#'   `https://github.com/LieberInstitute/megadepth/blob/master/R/megadepth.R`.
#'   The solution for the `permissions` of the `volumes` was taken from
#'   https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine.
#'
#' @examples
#'
#' docker_flags <- docker_run_rserver(return_flags = TRUE)
#'
#' # the docker command that would run on the system if return_flags = FALSE
#' paste(c("docker", docker_flags), collapse = " ")
docker_run_rserver <- function(image = "bioconductor/bioconductor_docker:RELEASE_3_13",
                               port = 8888,
                               password = "bioc",
                               name = "dz_bioc",
                               detach = TRUE,
                               rm = FALSE,
                               volumes = NULL,
                               volumes_ro = NULL,
                               permissions = "match",
                               USERID = 1002,
                               GROUPID = 1024,
                               verbose = TRUE,
                               return_flags = FALSE) {

  # set up the args for password and port
  docker_flags <- list(
    env = paste0("PASSWORD=", password),
    publish = paste0(port, ":8787"),
    detach = detach,
    rm = rm,
    name = name
  ) %>%
    cmdfun::cmd_list_interp() %>%
    cmdfun::cmd_list_to_flags(prefix = "--")

  # set up UID to match the host user
  # so volume permissions also match the host
  if (!is.null(permissions)) {
    if (permissions == "match") {
      permissions <- paste0(
        "--env USERID=", USERID, " ",
        "--env GROUPID=", GROUPID
      )
    } else {
      stop("permissions must be `match` or NULL")
    }
  }

  # set up volumes
  # either with permission
  if (!is.null(volumes)) {
    volumes <-
      volumes %>%
      .volumes_to_flag(read_only = FALSE)
  }

  if (!is.null(volumes_ro)) {
    volumes_ro <-
      volumes_ro %>%
      .volumes_to_flag(read_only = TRUE)
  }

  docker_flags <- c("run", docker_flags, permissions, volumes, volumes_ro, image)

  if (return_flags) {
    return(docker_flags)
  }

  if (verbose) {
    message(
      "Running docker with flags: ",
      stringr::str_c(docker_flags, collapse = " ")
    )
  }

  .docker_cmd(docker_flags)

  return(invisible())
}

#' @noRd
.volumes_to_flag <- function(volumes, read_only = FALSE) {
  . <- NULL

  # if you've already got a ":" in the volume
  # then leave it as is, otherwise mount volume as
  # identical path to host
  volumes_flag <- ifelse(stringr::str_detect(volumes, ":"),
    volumes,
    stringr::str_c(volumes, ":", volumes)
  )

  # prefix with the -v flag
  volumes_flag <- volumes_flag %>%
    stringr::str_c("-v ", .)

  if (read_only) {
    volumes_flag <-
      volumes_flag %>%
      stringr::str_c(., ":ro")
  }

  volumes_flag <-
    volumes_flag %>%
    stringr::str_c(collapse = " ")

  return(volumes_flag)
}

#' @noRd
.docker_cmd <- function(...) {
  system2("docker", ...)
}
