handle_build_exceptions <- function(target, meta, config){
  if (length(meta$warnings) && config$verbose){
    warn_opt <- max(1, getOption("warn"))
    withr::with_options(
      new = list(warn = warn_opt),
      drake_warning(
        "target ", target, " warnings:\n",
        multiline_message(meta$warnings),
        config = config
      )
    )
  }
  if (length(meta$messages) && config$verbose){
    drake_message(
      "Target ", target, " messages:\n",
      multiline_message(meta$messages),
      config = config
    )
  }
  if (inherits(meta$error, "error")){
    if (config$verbose){
      text <- paste("fail", target)
      finish_console(text = text, pattern = "fail", config = config)
    }
    store_failure(target = target, meta = meta, config = config)
    if (!config$keep_going){
      drake_error(
        "Target `", target, "` failed. Call `diagnose(", target,
        ")` for details. Error message:\n  ",
        meta$error$message,
        config = config
      )
    }
  }
}

error_character0 <- function(e){
  character(0)
}

error_false <- function(e){
  FALSE
}

error_na <- function(e){
  NA
}

error_null <- function(e){
  NULL
}

error_tibble_times <- function(e){
  stop(
    "Failed converting a data frame of times to a tibble. ",
    "Please install version 1.2.1 or greater of the pillar package.",
    call. = FALSE
  )
}

error_process <- function(e, id, config){
  set_attempt_flag(key = id, config = config)
  drake_message("Error: ", e$message, config = config)
  drake_message("Call: ", e$call, config = config)
  config$cache$set(key = id, value = e, namespace = "mc_fail")
  drake_error("make() failed.", config = config)
}

# Should be used as sparingly as possible.
just_try <- function(code){
  try(suppressWarnings(code), silent = TRUE)
}
