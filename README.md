
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rockup

<!-- badges: start -->

[![GitHub
issues](https://img.shields.io/github/issues/rytenlab/rockup)](https://github.com/rytenlab/rockup/issues)
[![GitHub
pulls](https://img.shields.io/github/issues-pr/rytenlab/rockup)](https://github.com/rytenlab/rockup/pulls)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check-bioc](https://github.com/rytenlab/rockup/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/rytenlab/rockup/actions)
[![Codecov test
coverage](https://codecov.io/gh/rytenlab/rockup/branch/main/graph/badge.svg)](https://app.codecov.io/gh/rytenlab/rockup?branch=main)
<!-- badges: end -->

The goal of `rockup` is to make it easy to connect to R Studio Server
via [rocker](https://github.com/rocker-org/rocker).

## Installation instructions

Install the development version of `rockup` from
[GitHub](https://github.com/rytenlab/rockup) with:

``` r
BiocManager::install("rytenlab/rockup")
```

## Basic usage

`rockup` has a single user-level function
[docker_run_rserver](https://rytenlab.github.io/rockup/reference/docker_run_rserver.html),
which is designed to start a container running R Studio Server on a
[rocker](https://github.com/rocker-org/rocker). Below is an example of
how to run `docker_run_rserver` with minimal config, for a more detailed
guide see the
[vignette](https://rytenlab.github.io/rockup/articles/rockup.html).

``` r
docker_run_rserver(
  image = "bioconductor/bioconductor_docker:RELEASE_3_13",
  port = 8888,
  name = "your_container_name"
)
```

## Code of Conduct

Please note that the `rockup` project is released with a [Contributor
Code of Conduct](http://bioconductor.org/about/code-of-conduct/). By
contributing to this project, you agree to abide by its terms.

## Development tools

-   Continuous code testing is possible thanks to [GitHub
    actions](https://www.tidyverse.org/blog/2020/04/usethis-1-6-0/)
    through *[usethis](https://CRAN.R-project.org/package=usethis)*,
    *[remotes](https://CRAN.R-project.org/package=remotes)*, and
    *[rcmdcheck](https://CRAN.R-project.org/package=rcmdcheck)*
    customized to use [Bioconductor’s docker
    containers](https://www.bioconductor.org/help/docker/) and
    *[BiocCheck](https://bioconductor.org/packages/3.14/BiocCheck)*.
-   Code coverage assessment is possible thanks to
    [codecov](https://codecov.io/gh) and
    *[covr](https://CRAN.R-project.org/package=covr)*.
-   The [documentation website](http://rytenlab.github.io/rockup) is
    automatically updated thanks to
    *[pkgdown](https://CRAN.R-project.org/package=pkgdown)*.
-   The code is styled automatically thanks to
    *[styler](https://CRAN.R-project.org/package=styler)*.
-   The documentation is formatted thanks to
    *[devtools](https://CRAN.R-project.org/package=devtools)* and
    *[roxygen2](https://CRAN.R-project.org/package=roxygen2)*.

For more details, check the `dev` directory.

This package was developed using
*[biocthis](https://bioconductor.org/packages/3.14/biocthis)*.
