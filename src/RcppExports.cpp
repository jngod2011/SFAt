// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// ll_cs_exp_cpp
double ll_cs_exp_cpp(const SEXP params, const SEXP y, const SEXP X, const int ineff, const bool deb);
RcppExport SEXP SFAt_ll_cs_exp_cpp(SEXP paramsSEXP, SEXP ySEXP, SEXP XSEXP, SEXP ineffSEXP, SEXP debSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< const SEXP >::type params(paramsSEXP);
    Rcpp::traits::input_parameter< const SEXP >::type y(ySEXP);
    Rcpp::traits::input_parameter< const SEXP >::type X(XSEXP);
    Rcpp::traits::input_parameter< const int >::type ineff(ineffSEXP);
    Rcpp::traits::input_parameter< const bool >::type deb(debSEXP);
    __result = Rcpp::wrap(ll_cs_exp_cpp(params, y, X, ineff, deb));
    return __result;
END_RCPP
}