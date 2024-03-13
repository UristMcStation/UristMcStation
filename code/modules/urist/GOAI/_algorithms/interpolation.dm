/* Linear interpolation, or 'LERP'; 2-ary weighted sum.
//
// - A & B - values to blend,
// - FRAC - fraction of value of B to add, as float 0->1. LERP(X, Y, 0) = X, LERP(X, Y, 1) = Y.
*/
# define LERP(A, B, FRAC) (((1-FRAC)*A) + ((FRAC)*B))

/* Inverse of LERP. Given a blended value and blend inputs, returns blend weight
//
// - A, B - values used for the LERP
// - VAL - LERPed value to unblend
//
// In general, UNLERP(A, B, LERP(A, B, FRAC)) == FRAC, assuming A != B.
// NOTE: undefined if A == B; we arbitrarily return 0.5 as a valid tie-breaker solution.
*/
# define UNLERP(A, B, VAL) ((B == A) ? 0.5 : ((VAL-A) / (B-A)))

/* Remaps a blend VAL of two values A1 & B1 onto an equivalent blend between A2 & B2
// Can be used for unit conversions (e.g. percents to fractions: LERP_REMAP(50, 0, 100, 0, 1) == 0.5)
//
// - VAL - LERPed value to remap to a new range
// - A1/B1 - A/B points for the original blend
// - A2/B2 - A/B points for the remap target
// NOTE: if A1 == B1; we arbitrarily return a 50% blend of A2/B2.
*/
# define LERP_REMAP(VAL, A1, B1, A2, B2) LERP(A2, B2, UNLERP(A1, B1, VAL))
