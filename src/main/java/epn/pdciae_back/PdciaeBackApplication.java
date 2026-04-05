package epn.pdciae_back;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@SpringBootApplication(scanBasePackages = "epn")
@EnableMongoRepositories(basePackages = "epn.repositories")
public class PdciaeBackApplication {
	private static final String[] MONGO_URI_ENV_KEYS = {
			"LOCAL_MONGODB_URI",
			"SPRING_DATA_MONGODB_URI",
			"MONGODB_URI",
			"MONGO_URI",
			"MONGODB_URL",
			"DATABASE_URL"
	};

	public static void main(String[] args) {
		configureMongoUriFromEnvironment();
		SpringApplication.run(PdciaeBackApplication.class, args);
	}

	private static void configureMongoUriFromEnvironment() {
		for (String key : MONGO_URI_ENV_KEYS) {
			String value = System.getenv(key);
			if (value != null && !value.isBlank()) {
				String uri = value.trim();
				System.setProperty("spring.data.mongodb.uri", uri);
				// Compatibilidad adicional por si alguna versión usa esta clave abreviada.
				System.setProperty("spring.mongodb.uri", uri);
				System.out.println("[MongoConfig] URI tomada desde " + key + " -> " + sanitizeMongoUri(uri));
				return;
			}
		}

		// Si no hay variables de entorno, forzamos la de Atlas para que funcione en
		// local
		String atlasUri = "mongodb+srv://render_user:Render123@pdciae.kmjvbbb.mongodb.net/pdciae?retryWrites=true&w=majority&appName=PDCIAE";
		System.setProperty("spring.data.mongodb.uri", atlasUri);
		System.setProperty("spring.mongodb.uri", atlasUri);

		System.out
				.println("[MongoConfig] Sin variable de entorno. Se ha forzado la URI de Atlas para desarrollo local.");
	}

	private static String sanitizeMongoUri(String uri) {
		int schemeIndex = uri.indexOf("://");
		if (schemeIndex < 0) {
			return "invalid-uri";
		}

		String scheme = uri.substring(0, schemeIndex + 3);
		String rest = uri.substring(schemeIndex + 3);
		int atIndex = rest.indexOf('@');
		if (atIndex >= 0) {
			rest = rest.substring(atIndex + 1);
		}

		int slashIndex = rest.indexOf('/');
		String hostAndParams = slashIndex >= 0 ? rest.substring(0, slashIndex) : rest;
		return scheme + hostAndParams;
	}

}
