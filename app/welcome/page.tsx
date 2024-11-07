"use client";

import { useState } from "react";
import { motion } from "framer-motion";
import { Button } from "@/components/ui/button";
import { Gift, Users, Calendar, Sparkles } from "lucide-react";

export default function Component() {
  const features = [
    {
      icon: <Gift className="w-6 h-6" />,
      title: "Multiple Lists",
      description:
        "Create different wishlists to share with friends, family, or your significant other.",
    },
    {
      icon: <Users className="w-6 h-6" />,
      title: "Gift Exchanges",
      description: "Organize and manage gift exchanges for any occasion.",
    },
    {
      icon: <Calendar className="w-6 h-6" />,
      title: "Birthday Coordination",
      description: "Coordinate birthday gifts with an integrated event chat.",
    },
    {
      icon: <Sparkles className="w-6 h-6" />,
      title: "Secret Gift Ideas",
      description:
        "Keep track of potential gift ideas for friends and secretly add to their lists.",
    },
  ];

  return (
    <div className="min-h-screen bg-gray-900 text-white">
      <header className="container mx-auto px-4 py-6">
        <nav className="flex justify-between items-center">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5 }}
          >
            <h1 className="text-2xl font-bold text-purple-400">iWish</h1>
          </motion.div>
        </nav>
      </header>

      <main className="container mx-auto px-4 py-12">
        <section className="text-center mb-20">
          <motion.h2
            className="text-4xl md:text-5xl font-bold mb-4 text-purple-300"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7 }}
          >
            Your Wishes, Your Way
          </motion.h2>
          <motion.p
            className="text-xl mb-8 text-gray-300"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.2 }}
          >
            Create, manage, and share your wishlists for every occasion and
            relationship.
          </motion.p>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.4 }}
          >
            <Button
              size="lg"
              className="bg-purple-600 text-white hover:bg-purple-700"
            >
              Get Started
            </Button>
          </motion.div>
        </section>

        <section className="grid md:grid-cols-2 gap-8 mb-20">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              className="bg-gray-800 p-6 rounded-lg shadow-lg"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              whileHover={{ scale: 1.05 }}
            >
              <div className="text-purple-400 mb-4">{feature.icon}</div>
              <h3 className="text-lg font-semibold mb-2 text-white">
                {feature.title}
              </h3>
              <p className="text-gray-300">{feature.description}</p>
            </motion.div>
          ))}
        </section>

        <section className="text-center">
          <motion.h2
            className="text-3xl font-bold mb-4 text-purple-300"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7 }}
          >
            Ready to Start Wishing?
          </motion.h2>
          <motion.p
            className="text-xl mb-8 text-gray-300"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.2 }}
          >
            Join thousands of users and start creating your personalized
            wishlists today.
          </motion.p>
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.4 }}
          >
            <Button
              size="lg"
              className="bg-purple-600 text-white hover:bg-purple-700"
            >
              Sign Up Now
            </Button>
          </motion.div>
        </section>
      </main>

      <footer className="container mx-auto px-4 py-6 mt-12 text-center text-gray-400">
        <p>&copy; {new Date().getFullYear()} iWish. All rights reserved.</p>
      </footer>
    </div>
  );
}
