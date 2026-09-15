/** Claims do access token (JWT). `sub` é o id do Admin. */
export interface AccessTokenPayload {
  sub: string;
  email: string;
}

/** O que os handlers recebem via @CurrentAdmin(). */
export interface AuthenticatedAdmin {
  id: string;
  email: string;
}
