#' Risk-weighted Asset (RWA) and the required capital, k, calculation for retail portfolios under the
#' BasellII framework
#' 
#' @param pd The probability of default (PD) of the record
#' @param lgd The loss given default (LGD) of the record
#' @param asset.class The assest class of the account
#' @param r The assest correlation. Usually not required as it is specifeid under BaselII bassed on asset class
#' @param reg.mult Regulator specified multiplier to the RWA
#' @export
#' 
k.capital <- function(pd, lgd, asset.class = c("Mortgage", "QRRE", "Retail Other"), r = NULL) {
  #browser()
  # the correlation
  asset.class <- match.arg(asset.class)
  if(is.null(r)) {
    if (asset.class == "Mortgage") {
      r <- 0.15
    } else if (asset.class == "QRRE")    {
      r <- 0.04
    } else if (asset.class == "Retail Other")    {
      r <- 0.03*(1-exp(-35*pd))/(1-exp(-35))+0.16*(1-(1-exp(-35*pd)))/(1-exp(-35))
    }
  }
  
  lgd*(pnorm(sqrt(1/(1-r))*qnorm(0.999) + sqrt(r/(1-r))*qnorm(pd)) - pd)
}



#' @rdname k.capital
#' @param ead The exposure at default in dollar amount. If not specified the 
#'   function returns the RWA\%
#' @examples
#' rwa(pd = 0.01, lgd = 0.2) 
#' 
#' # sometimes the regulator may impose a different correlation to the Basel II
#' # standard. YOu can use r to get the correaltion
#' rwa(pd = 0.01, lgd = 0.2, r = 0.21) 
#' @export
rwa <- function(..., ead = 1, reg.mult = 1) {
  k <- k.capital(...)
  12.5 * k * reg.mult * ead
}