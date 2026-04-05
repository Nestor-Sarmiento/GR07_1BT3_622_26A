package epn.pdciae_back;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@SpringBootApplication(scanBasePackages = "epn")
@EnableMongoRepositories(basePackages = "epn.repositories")
public class PdciaeBackApplication {
	private static final String[] MONGO_URI_ENV_KEYS = {
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

		throw new IllegalStateException(
			"MongoDB URI no configurada. Define una variable de entorno: " + String.join(", ", MONGO_URI_ENV_KEYS)
		);
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
