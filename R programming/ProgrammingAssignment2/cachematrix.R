# Cache Matrix Function: create a matrix that cache its inverse
# which is really a list containing a function to

makeCacheMatrix <- function(x = numeric()) {
      s <- NULL
      set <- function(y) {
            # set the matrix
            x <<- y
            s <<- NULL
      }
      # get the matrix
      get <- function() x
      # set the inverse
      setInverse <- function(inverse) s <<- solve
      # get the inverse
      getInverse <- function() s
      list(set = set, get = get,
           setInverse = setInverse,
           getInverse = getInverse)
}


# Computes the inverse of the special "matrix" returned by makeCacheMatrix above. 
# If the inverse has already been calculated (and the matrix has not changed), 
# then the cachesolve should retrieve the inverse from the cache.

cacheSolve <- function(x, ...) {
      # get inverse
      inv <- x$getInverse()
      # see if inverse has been already calculated
      if(!is.null(inv)) {
            message("getting cached data")
            return(inv)
      }
      # if not calculate inverse
      data <- x$get()
      inv <- solve(data, ...)
      x$setInverse(inv)
      inv
}