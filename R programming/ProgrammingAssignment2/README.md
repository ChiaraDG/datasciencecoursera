### Programming Assignment 2: Caching the Inverse of a Matrix

Write a function in R that is able to cache the inverse of a matrix. The file cachematrix.R contains two functions: 

- makeCacheMatrix: create a matrix that can cache its inverse

- cacheSolve: compute the inverse on the matrix created using makeCacheMatrix. If the inverse has already been calculated (and the matrix has not changed), then the cachesolve should retrieve the inverse from the cache.

Below is a small demo of the functions created:


```r
source("cachematrix.R")

# create a matrix that can cache its inverse
my_mat <- makeCacheMatrix(matrix(1:4,nrow = 2))
# matrix created
my_mat$get()
```

```
##      [,1] [,2]
## [1,]    1    3
## [2,]    2    4
```

```r
# compute the inverse
cacheSolve(my_mat)
```

```
##      [,1] [,2]
## [1,]   -2  1.5
## [2,]    1 -0.5
```

If we try to compute the inverse of the same matrix we should now get a message saying "get cache data".


```r
cacheSolve(my_mat)
```

```
## getting cached data
```

```
##      [,1] [,2]
## [1,]   -2  1.5
## [2,]    1 -0.5
```
