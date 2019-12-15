
batch_neutralize <- function (dat, fbatch, half = TRUE, sqrt.trans = TRUE) 
{
  Z <- dat
  if (sqrt.trans) 
    Z <- sqrt(dat)
  if (!half) 
    ocont <- options(contrasts = c("contr.treatment", "contr.poly"))
  if (half) 
    ocont <- options(contrasts = c("contr.sum", "contr.poly"))
  n <- ncol(dat)
  X <- model.matrix(~fbatch)
  options(contrasts = ocont$contrasts)
  XinvXX <- X %*% solve(t(X) %*% X)
  B <- Z %*% XinvXX
  dat <- Z - B[, -1, drop = FALSE] %*% t(X[, -1, drop = FALSE])
  if (sqrt.trans) 
    dat <- dat^2
  dat
}