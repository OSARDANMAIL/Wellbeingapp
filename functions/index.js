const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();

exports.updateAIMealPlan = functions.pubsub.schedule('every monday 00:00')
    .timeZone('UTC')
    .onRun(async (context) => {
        const db = admin.firestore();

        // 🔹 AI API call
        const apiKey = "32f6d244561948abaf491357af8abd11"; // �� Replace with your actual API key
        const url = `https://api.spoonacular.com/mealplanner/generate?timeFrame=week&apiKey=${apiKey}`;
        const response = await fetch(url);
        const aiMeals = await response.json();

        if (!aiMeals || !aiMeals.week) {
            console.error("❌ AI meal plan fetch failed.");
            return null;
        }

        // 🔹 Format AI response to Firestore structure
        const mealData = Object.entries(aiMeals.week).map(([day, meals]) => ({
            day: day.toLowerCase(),
            goal: "healthy",  // Change dynamically if needed
            meals: meals.meals.map(meal => ({
                name: meal.title,
                calories: meal.nutrition.calories,
                protein: meal.nutrition.protein,
                carbs: meal.nutrition.carbs,
                fats: meal.nutrition.fat,
                healthBenefits: "AI-generated meal for a balanced diet.",
                completedBy: {} // Track users who completed it
            }))
        }));

        // 🔹 Update Firestore
        for (const meal of mealData) {
            await db.collection("mealPlanner").doc(meal.day).set(meal);
        }

        console.log("✅ AI Meal Plan Updated in Firestore!");
    });

