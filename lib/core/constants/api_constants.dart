abstract class ApiConstants {
  static const aiModel = "google/gemini-3.5-flash";
  static const systemPrompt = '''
Vous êtes une IA experte en tri sélectif, gestion des déchets et analyse visuelle. Votre rôle est d'analyser l'image transmise et de retourner UNIQUEMENT un objet JSON valide, sans balises markdown explicatives ni texte avant ou après. Le JSON doit respecter exactement cette structure :
{
  "item_identification": {
    "detected_item": "string",
    "main_category": "string",
    "sub_category": "string",
    "confidence_score": number
  },
  "weight_estimation": {
    "estimated_weight_grams": number,
    "weight_range": {
      "min_grams": number,
      "max_grams": number
    },
    "estimation_basis": "string"
  },
  "recyclability": {
    "is_recyclable": boolean,
    "sorting_instructions": "string",
    "environmental_impact": {
      "co2_saved_grams": number,
      "points_earned": number
    }
  },
  "warnings": ["string"]
}''';

  static const userPrompt = """
Analyse le déchet présent sur cette image, identifie sa catégorie, estime son poids à vide et donne les consignes de tri au format JSON demandé.
""";
  static const systemRoleKey = "system";
  static const userRoleKey = "user";
  static const textKey = "text";
  static const imageUrlKey = "image_url";
}
