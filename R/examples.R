#' @title Save the source code files of a drake example.
#' @description Copy a folder of code files for a
#' drake example to the current working directory.
#' Call `drake_example("mtcars")` to generate the code files from the
#' mtcars example vignette: `vignette("example-mtcars")`.
#' To see the names of all the examples, run [drake_examples()].
#' @seealso [drake_examples()], [make()],
#'   [shell_file()], [drake_batchtools_tmpl_file()]
#' @export
#' @return `NULL`
#' @param example name of the example.
#'   To see all the available example names,
#'   run [drake_examples()].
#' @param to Character scalar, file path, where
#'   to write the folder containing the code files for the example.
#' @param destination Deprecated, use `to` instead.
#' @param overwrite Logical, whether to overwrite an existing folder
#'   with the same name as the drake example.
#' @examples
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' drake_examples() # List all the drake examples.
#' # Sets up the same example as the mtcars example vignette.
#' drake_example("mtcars")
#' # Sets up the SLURM example.
#' drake_example("slurm")
#' })
#' }
drake_example <- function(
  example = drake::drake_examples(),
  to = getwd(),
  destination = NULL,
  overwrite = FALSE
){
  if (!is.null(destination)){
    warning(
      "The 'destination' argument of drake_example() is deprecated. ",
      "Use 'to' instead."
    )
    to <- destination
  }
  example <- match.arg(example)
  dir <- system.file(file.path("examples", example), package = "drake",
    mustWork = TRUE)
  file.copy(from = dir, to = to,
    overwrite = overwrite, recursive = TRUE)
  invisible()
}

#' @title List the names of all the drake examples.
#' @description The `'mtcars'` example is the one from the
#' mtcars example vignette: `vignette("example-mtcars")`.
#' All are in the `inst/examples/` folder
#' of the package source code.
#' @export
#' @seealso [drake_example()], [make()]
#' @return Names of all the drake examples.
#' @examples
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' drake_examples() # List all the drake examples.
#' # Sets up the same example as the mtcars example vignette.
#' drake_example("mtcars")
#' # Sets up the SLURM example.
#' drake_example("slurm")
#' })
#' }
drake_examples <- function() {
  list.dirs(system.file("examples", package = "drake", mustWork = TRUE),
    full.names = FALSE, recursive = FALSE)
}
