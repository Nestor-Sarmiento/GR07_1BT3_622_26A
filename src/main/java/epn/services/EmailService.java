package epn.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    
    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    private static final String SENDER_EMAIL = "noreply@owlshare.com";
    
    /**
     * Envía un email con la contraseña temporal al nuevo administrador
     * 
     * @param recipientEmail Email del nuevo administrador
     * @param recipientName Nombre del nuevo administrador
     * @param temporaryPassword Contraseña temporal generada
     */
    public void sendTemporaryPasswordEmail(String recipientEmail, String recipientName, String temporaryPassword) {
        if (mailSender == null) {
            System.out.println("[EmailService] JavaMailSender no configurado. Email NO ENVIADO a " + recipientEmail);
            System.out.println("[EmailService] Contraseña temporal sería: " + temporaryPassword);
            return;
        }
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(SENDER_EMAIL);
            message.setTo(recipientEmail);
            message.setSubject("Credenciales de Acceso - OwlShare");
            
            String body = String.format(
                "Estimado/a %s,\n\n" +
                "Has sido designado como Administrador en la plataforma OwlShare.\n\n" +
                "Para acceder, utiliza las siguientes credenciales temporales:\n" +
                "Email: %s\n" +
                "Contraseña temporal: %s\n\n" +
                "IMPORTANTE: Debes cambiar tu contraseña en el siguiente inicio de sesión.\n" +
                "La contraseña temporal expirará después de tu primer acceso.\n\n" +
                "Si tienes problemas para acceder, contacta al soporte técnico.\n\n" +
                "Saludos,\n" +
                "Equipo OwlShare",
                recipientName,
                recipientEmail,
                temporaryPassword
            );
            
            message.setText(body);
            
            mailSender.send(message);
            System.out.println("[EmailService] ✅ Email enviado a " + recipientEmail);
        } catch (Exception e) {
            System.err.println("[EmailService] ❌ Error al enviar email a " + recipientEmail + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Envía notificación de que la contraseña fue cambiada exitosamente
     */
    public void sendPasswordChangedEmail(String recipientEmail, String recipientName) {
        if (mailSender == null) {
            System.out.println("[EmailService] JavaMailSender no configurado. Notificación de cambio de password NO ENVIADA a " + recipientEmail);
            return;
        }
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(SENDER_EMAIL);
            message.setTo(recipientEmail);
            message.setSubject("Contraseña Actualizada - OwlShare");
            
            String body = String.format(
                "Estimado/a %s,\n\n" +
                "Tu contraseña ha sido actualizada exitosamente.\n\n" +
                "Puedes acceder a la plataforma con tus nuevas credenciales.\n\n" +
                "Si no realizaste este cambio, contacta inmediatamente al soporte técnico.\n\n" +
                "Saludos,\n" +
                "Equipo OwlShare",
                recipientName
            );
            
            message.setText(body);
            mailSender.send(message);
            System.out.println("[EmailService] ✅ Notificación de cambio de password enviada a " + recipientEmail);
        } catch (Exception e) {
            System.err.println("[EmailService] ❌ Error al enviar notificación a " + recipientEmail + ": " + e.getMessage());
        }
    }
}
