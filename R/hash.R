#' @title List the available hash algorithms for drake caches.
#' @export
#' @description See the advanced storage tutorial
#' at <https://github.com/ropensci/drake/blob/master/vignettes/storage.Rmd>
#' for details.
#' @return A character vector of names of available hash algorithms.
#' @examples
#' available_hash_algos()
available_hash_algos <- function(){
  eval(formals(digest::digest)$algo)
}

#' @title Get the long hash algorithm of a drake cache.
#' @export
#' @seealso [default_short_hash_algo()],
#'   [default_long_hash_algo()]
#' @description  See the advanced storage tutorial
#' at <https://github.com/ropensci/drake/blob/master/vignettes/storage.Rmd>
#' for details.
#' @return A character vector naming a hash algorithm.
#' @inheritParams cached
#' @examples
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' load_mtcars_example() # Get the code with drake_example("mtcars").
#' # Run the project and return the internal master configuration list.
#' config <- make(my_plan)
#' # Locate the storr cache.
#' cache <- config$cache
#' # Get the long hash algorithm of the cache.
#' long_hash(cache)
#' })
#' }
long_hash <- function(
  cache = drake::get_cache(verbose = verbose),
  verbose = drake::default_verbose()
){
  if (!cache$exists(key = "long_hash_algo", namespace = "config")){
    return(NULL)
  }
  cache$get("long_hash_algo", namespace = "config")
}

#' @title Get the short hash algorithm of a drake cache.
#' @export
#' @seealso [default_short_hash_algo()],
#'   [default_long_hash_algo()]
#' @description See the advanced storage tutorial
#' at <https://github.com/ropensci/drake/blob/master/vignettes/storage.Rmd>
#' for details.
#' @return A character vector naming a hash algorithm.
#' @inheritParams cached
#' @examples
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' load_mtcars_example() # Get the code with drake_example("mtcars").
#' # Run the project and return the internal master configuration list.
#' config <- make(my_plan)
#' # Locate the storr cache.
#' cache <- config$cache
#' # Get the short hash algorithm of the cache.
#' short_hash(cache)
#' })
#' }
short_hash <- function(
  cache = drake::get_cache(verbose = verbose),
  verbose = drake::default_verbose()
){
  if (!cache$exists(key = "short_hash_algo", namespace = "config")){
    return(NULL)
  }
  chosen_algo <- cache$get("short_hash_algo", namespace = "config")
  check_storr_short_hash(cache = cache, chosen_algo = chosen_algo)
  cache$get("short_hash_algo", namespace = "config")
}

#' @title Return the default short hash algorithm for `make()`.
#' @export
#' @seealso [make()], [available_hash_algos()]
#' @description See the advanced storage tutorial
#' at <https://github.com/ropensci/drake/blob/master/vignettes/storage.Rmd>
#' for details.
#' @details
#' The short algorithm must be among \code{\link{available_hash_algos}{}},
#' which is just the collection of algorithms available to the `algo`
#' argument in [digest::digest()]. \cr \cr
#'
#' If you express no preference for a hash, drake will use
#' the short hash for the existing project, or
#' [default_short_hash_algo()] for a new project.
#' If you do supply a hash algorithm, it will only apply to
#' fresh projects (see \code{\link{clean}(destroy = TRUE)}).
#' For a project that already exists, if you supply a hash algorithm,
#' drake will warn you and then ignore your choice, opting instead for
#' the hash algorithm already chosen for the project
#' in a previous `make()`. \cr \cr
#'
#' Drake uses both a short hash algorithm
#' and a long hash algorithm. The shorter hash has fewer characters,
#' and it is used to generate the names of internal cache files
#' and auxiliary files. The decision for short names is important
#' because Windows places restrictions on the length of file paths.
#' On the other hand, some internal hashes in drake are
#' never used as file names, and those hashes can use a longer hash
#' to avoid collisions.
#'
#' @return A character vector naming a hash algorithm.
#'
#' @param cache optional drake cache.
#'   When you \code{\link{configure_cache}(cache)} without
#'   supplying a short hash algorithm,
#'   `default_short_hash_algo(cache)` is the short
#'   hash algorithm that drake picks for you.
#'
#' @examples
#' default_short_hash_algo()
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' load_mtcars_example() # Get the code with drake_example("mtcars").
#' # Run the project and return the internal master configuration list.
#' config <- make(my_plan)
#' # Locate the storr cache.
#' cache <- config$cache
#' # Get the default short hash algorithm of an existing cache.
#' default_short_hash_algo(cache)
#' })
#' }
default_short_hash_algo <- function(cache = NULL) {
  out <- "xxhash64"
  if (is.null(cache)){
    return(out)
  }
  if (cache$exists(key = "short_hash_algo", namespace = "config")){
    out <- cache$get(
      key = "short_hash_algo",
      namespace = "config"
    )
  }
  if ("storr" %in% class(cache)){
    out <- cache$driver$hash_algorithm
  }
  out
}

#' @title Return the default long hash algorithm for `make()`.
#' @export
#' @seealso [make()], [available_hash_algos()]
#' @description See the advanced storage tutorial
#' at <https://github.com/ropensci/drake/blob/master/vignettes/storage.Rmd>
#' for details.
#' @details
#' The long algorithm must be among \code{\link{available_hash_algos}{}},
#' which is just the collection of algorithms available to the `algo`
#' argument in `digest::digest()`. \cr \cr
#'
#' If you express no preference for a hash, drake will use
#' the long hash for the existing project, or
#' [default_long_hash_algo()] for a new project.
#' If you do supply a hash algorithm, it will only apply to
#' fresh projects (see \code{\link{clean}(destroy = TRUE)}).
#' For a project that already exists, if you supply a hash algorithm,
#' drake will warn you and then ignore your choice, opting instead for
#' the hash algorithm already chosen for the project
#' in a previous `make()`. \cr \cr
#'
#' Drake uses both a short hash algorithm
#' and a long hash algorithm. The shorter hash has fewer characters,
#' and it is used to generate the names of internal cache files
#' and auxiliary files. The decision for short names is important
#' because Windows places restrictions on the length of file paths.
#' On the other hand, some internal hashes in drake are
#' never used as file names, and those hashes can use a longer hash
#' to avoid collisions.
#'
#' @return A character vector naming a hash algorithm.
#'
#' @param cache optional drake cache.
#'   When you \code{\link{configure_cache}(cache)} without
#'   supplying a long hash algorithm,
#'   `default_long_hash_algo(cache)` is the long
#'   hash algorithm that drake picks for you.
#'
#' @examples
#' default_long_hash_algo()
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' load_mtcars_example() # Get the code with drake_example("mtcars").
#' # Run the project and return the internal master configuration list.
#' config <- make(my_plan)
#' # Locate the storr cache.
#' cache <- config$cache
#' # Get the default long hash algorithm of an existing cache.
#' default_long_hash_algo(cache)
#' })
#' }
default_long_hash_algo <- function(cache = NULL) {
  out <- "sha256"
  if (is.null(cache)){
    return(out)
  }
  if (cache$exists(key = "long_hash_algo", namespace = "config")){
    out <- cache$get(
      key = "long_hash_algo",
      namespace = "config"
    )
  }
  out
}

check_storr_short_hash <- function(cache, chosen_algo){
  if (!inherits(cache, "storr")){
    return()
  }
  true_algo <- cache$driver$hash_algorithm
  if (!identical(true_algo, chosen_algo)){
    warning(
      "The storr-based cache actually uses ", true_algo,
      " for the short hash algorithm, but ", chosen_algo,
      " was also supplied. Reverting to ", true_algo, ".",
      call. = FALSE
    )
    cache$set(
      key = "short_hash_algo",
      value = true_algo,
      namespace = "config"
    )
  }
}
