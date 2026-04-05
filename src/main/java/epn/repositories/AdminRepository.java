package epn.repositories;

import epn.schemas.Admin;
import org.springframework.data.mongodb.repository.MongoRepository;
// findyby finds delete create
public interface AdminRepository extends MongoRepository<Admin, String> {
}
