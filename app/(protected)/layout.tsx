import { auth } from "@/lib/auth";
import React from "react";
import AuthPage from "../signin/page";

export default async function ProtectedLayout({
  children,
}: Readonly<{ children: React.ReactNode }>) {
  const session = await auth();
  if (!session) {
    return <AuthPage />;
  }
  return children;
}
