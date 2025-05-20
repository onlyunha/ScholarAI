from sentence_transformers import SentenceTransformer, util

class FAQEmbedder:
    def __init__(self, model_name="BM-K/KoSimCSE-roberta"):
        self.model = SentenceTransformer(model_name)

    def find_best_match(self, user_input, faq_data):
        faq_questions = [item["질문"] for item in faq_data]
        faq_embeddings = self.model.encode(faq_questions)
        user_embedding = self.model.encode([user_input])[0]
        similarities = util.cos_sim(user_embedding, faq_embeddings)[0]
        best_index = similarities.argmax()
        return faq_data[best_index]
