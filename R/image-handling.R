



#' @title Flip coordinates
#'
#' @description Flips coordinate dimensions along the y-axis to align with image in case
#' of non matching image and coordinates.
#'
#' @inherit argument_dummy params
#'
#' @return An updated spata-object.
#'
#' @export
#'
flipCoords <- function(object, verbose = FALSE){

  if(!containsImage(object)){

    if(base::isTRUE(verbose)){

      warning("Can not flip coordinates without an image.")

    }

  } else {

    yrange <- getImageRange(object)$y

    coords_df <- getCoordsDf(object)

    coords_df$y <- yrange[2] - coords_df$y + yrange[1]

    object <- setCoordsDf(object, coords_df)

    object@images[[1]]@coordinates <- coords_df

  }

  return(object)

}


#' @title Mirror invert the surface
#'
#' @description Flips both and coordinates which results in mirror inverted plots.
#'
#' @inherit argument_dummy params
#'
#' @return An updated spata-object.
#' @export
#'
flipImageAndCoords <- function(object){

  object <- flipCoords(object)

  object <- flipImage(object)

  return(object)

}

#' @title Flip object image
#'
#' @description Flips image dimensions to align with coordinates in case
#' of non matching image and coordinates.
#'
#' @param axis Character value. Either \emph{'x'} or \emph{'y'}. Denotes
#' the axis around which the image is flipped.
#' @inherit argument_dummy params
#'
#' @return An updated spata-object.
#' @export
#'

flipImage <- function(object, axis = "x"){

  of_sample <- check_sample(object)

  io <- getImageObject(object)

  if(base::is.null(io@info$flipped)){

    io@info$flipped <- FALSE

  }

  io@info$flipped <- !io@info$flipped

  if(axis == "x"){

    io@image <- EBImage::flip(io@image)

  } else if(axis == "y"){

    io@image <- EBImage::flop(io@image)

  } else {

    stop("Axis must either be 'x' or 'y'.")

  }

  object <- setImageObject(object, image_object = io)

  return(object)

}

#' @rdname flipImage
#' @export
rotateImage <- function(object, angle){

  stopifnot(angle %in% c(90, 180))

  io <- getImageObject(object)

  io@image <- EBImage::rotate(x = io@image, angle = angle)

  object <- setImageObject(object, image_object = io)

  return(object)

}
