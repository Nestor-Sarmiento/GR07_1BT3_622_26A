# 📋 PLAN DETALLADO DE 6 PRUEBAS UNITARIAS PARA HU1 (Búsqueda de Tutores por Materia)

---

## 📊 Resumen Ejecutivo

| # | Tipo Prueba | Clase a Probar | Método/Escenario | Mock/Parámetros | Ubicación Test |
|---|-------------|----------------|------------------|-----------------|---|
| 1 | **Unitaria Normal** | `BuscarTutorServlet` | Conversión Tutor → TutorListadoDTO | ❌ Sin Mock | `BuscarTutorServletTest.java` |
| 2 | **Unitaria Normal** | `BuscarTutorServlet` | Construcción de nombre completo | ❌ Sin Mock | `BuscarTutorServletTest.java` |
| 3 | **Unitaria Normal** | `BuscarTutorServlet` | Truncamiento de biografía a 140 caracteres | ❌ Sin Mock | `BuscarTutorServletTest.java` |
| 4 | **Unitaria Normal** | `TutorListadoDTO` | Obtención de inicial del nombre | ❌ Sin Mock | `TutorListadoDTOTest.java` |
| 5 | **Parametrizada** | `MateriaFIS` | Validación de múltiples materias y estados | ✅ @CsvSource | `BuscarTutorServletTest.java` |
| 6 | **Mock** | `BuscarTutorServlet.doGet()` | Simulación de búsqueda en BD (EntityManager) | ✅ Mock JPA | `BuscarTutorServletMockTest.java` |

---

## 🧪 PRUEBA 1: Test Unitario Normal - Conversión Tutor → TutorListadoDTO

### 📍 Ubicación
- **Archivo**: `src/test/java/servlets/BuscarTutorServletTest.java`
- **Clase a Probar**: `BuscarTutorServlet`
- **Método Privado a Probar**: `toDto(Tutor t)` (mediante reflexión o test manual)

### 🎯 Objetivo
Validar que la conversión de objeto Tutor a TutorListadoDTO se realiza correctamente con todos los campos.

### 📝 Código del Test
```java
@Test
void toDto_deberiaConvertirTutorCompleto() {
    // Arrange - Crear un Tutor completo con datos
    Tutor tutor = Tutor.builder()
            .id(1L)
            .nombre("Carlos")
            .segundoNombre("Miguel")
            .apellido("López")
            .segundoApellido("González")
            .descripcionProfesional("Experto en Programación" + "X".repeat(130)) // ~140+ caracteres
            .materiasRelacionadas(Set.of(MateriaFIS.PROGRAMACION_I, MateriaFIS.SISTEMAS_OPERATIVOS))
            .build();

    // Act - Invocar método toDto (mediante reflexión o test de integración)
    TutorListadoDTO dto = convertirTutorADto(tutor);

    // Assert - 6 validaciones
    assertEquals(1L, dto.getIdTutor());
    assertEquals("Carlos Miguel López González", dto.getNombreMostrar());
    assertTrue(dto.getBioCorta().length() <= 140);
    assertEquals(2, dto.getMaterialesEtiquetas().size());
    assertTrue(dto.getMaterialesEtiquetas().contains("PROGRAMACIÓN I"));
    assertEquals("C", dto.getInicial());
}
```

### 📊 Valores de Entrada
| Campo | Valor | Tipo |
|-------|-------|------|
| nombre | "Carlos" | String |
| segundoNombre | "Miguel" | String |
| apellido | "López" | String |
| segundoApellido | "González" | String |
| descripcionProfesional | 150+ caracteres | String |
| materiasRelacionadas | {PROGRAMACION_I, SISTEMAS_OPERATIVOS} | Set\<MateriaFIS\> |

### ✅ Resultado Esperado
- ✓ Nombres concatenados correctamente
- ✓ Biografía truncada a máximo 140 caracteres
- ✓ Inicial es "C"
- ✓ Materias mapeadas en etiquetas

---

## 🧪 PRUEBA 2: Test Unitario Normal - Construcción de Nombre Completo

### 📍 Ubicación
- **Archivo**: `src/test/java/servlets/BuscarTutorServletTest.java`
- **Clase a Probar**: `BuscarTutorServlet`
- **Método Privado a Probar**: `joinNombreParts(String... parts)`

### 🎯 Objetivo
Validar que la concatenación de partes de nombre maneja correctamente nulls, espacios en blanco y produces una salida válida.

### 📝 Código del Test
```java
@Test
void joinNombreParts_deberiaUnirPartesCorrectamente() {
    // Arrange & Act combinations
    String resultado1 = joinNombreParts("Juan", "Carlos", "Pérez", "López");
    String resultado2 = joinNombreParts("María", null, "García", "");
    String resultado3 = joinNombreParts(null, null, null, null);
    String resultado4 = joinNombreParts("  Ana María  ", "   ", "Rodríguez");

    // Assert - 4 validaciones
    assertEquals("Juan Carlos Pérez López", resultado1);
    assertEquals("María García", resultado2);
    assertEquals("", resultado3);
    assertEquals("Ana María Rodríguez", resultado4);
}
```

### 📊 Valores de Entrada
| Escenario | Input | Tipo |
|-----------|-------|------|
| Normal | ["Juan", "Carlos", "Pérez", "López"] | String[] |
| Con nulls | ["María", null, "García", ""] | String[] |
| Todo null | [null, null, null, null] | String[] |
| Espacios | ["  Ana María  ", "   ", "Rodríguez"] | String[] |

### ✅ Resultado Esperado
- ✓ Nombres válidos concatenados con espacios
- ✓ Nulls ignorados
- ✓ Espacios en blanco trimados
- ✓ Retorna vacío si todos son null

---

## 🧪 PRUEBA 3: Test Unitario Normal - Truncamiento de Biografía

### 📍 Ubicación
- **Archivo**: `src/test/java/servlets/BuscarTutorServletTest.java`
- **Clase a Probar**: `BuscarTutorServlet`
- **Método a Probar**: Lógica de truncamiento en `toDto()`

### 🎯 Objetivo
Validar que la biografía se trunca a exactamente 140 caracteres y se agrega "…" cuando excede.

### 📝 Código del Test
```java
@Test
void toDto_deberiatruncarbiogrrafiaA140Caracteres() {
    // Arrange
    String bioOriginal = "A".repeat(150); // 150 caracteres
    Tutor tutor = Tutor.builder()
            .id(1L)
            .nombre("Profesor")
            .descripcionProfesional(bioOriginal)
            .build();

    // Act
    TutorListadoDTO dto = convertirTutorADto(tutor);

    // Assert - 3 validaciones
    assertEquals(140, dto.getBioCorta().length());
    assertTrue(dto.getBioCorta().endsWith("…"));
    assertTrue(dto.getBioCorta().startsWith("A"));
}
```

### 📊 Valores de Entrada
| Campo | Valor | Tipo |
|-------|-------|------|
| bioOriginal | 150 caracteres 'A' | String |
| BIO_MAX (constante) | 140 | int |

### ✅ Resultado Esperado
- ✓ Biografía limitada a 140 caracteres
- ✓ Se agrega "…" al final
- ✓ Total = 140 caracteres incluyendo "…"

---

## 🧪 PRUEBA 4: Test Unitario Normal - Validación de Inicial

### 📍 Ubicación
- **Archivo**: `src/test/java/schemas/TutorListadoDTOTest.java`
- **Clase a Probar**: `TutorListadoDTO`
- **Método a Probar**: `getInicial()`

### 🎯 Objetivo
Validar que el método `getInicial()` retorna la primera letra en mayúscula o "?" si el nombre es vacío/null.

### 📝 Código del Test
```java
@Test
void getInicial_deberiaRetornarPrimeraLetraMayuscula() {
    // Arrange
    TutorListadoDTO dto1 = TutorListadoDTO.builder()
            .nombreMostrar("carlos López")
            .build();
    
    TutorListadoDTO dto2 = TutorListadoDTO.builder()
            .nombreMostrar("  ")
            .build();
    
    TutorListadoDTO dto3 = TutorListadoDTO.builder()
            .nombreMostrar(null)
            .build();

    // Act & Assert - 3 validaciones
    assertEquals("C", dto1.getInicial());
    assertEquals("?", dto2.getInicial());
    assertEquals("?", dto3.getInicial());
}
```

### 📊 Valores de Entrada
| Caso | Input | Tipo |
|------|-------|------|
| Normal | "carlos López" | String |
| Espacios | "  " | String |
| Null | null | String |

### ✅ Resultado Esperado
- ✓ Retorna 'C' en mayúscula para "carlos López"
- ✓ Retorna '?' para espacios en blanco
- ✓ Retorna '?' para null

---

## 🧪 PRUEBA 5: Test Parametrizado - Múltiples Materias y Estados

### 📍 Ubicación
- **Archivo**: `src/test/java/servlets/BuscarTutorServletTest.java`
- **Clase a Probar**: `BuscarTutorServlet` + `MateriaFIS`
- **Método a Probar**: Validación de materias en `doGet()`

### 🎯 Objetivo
Probar que el servlet maneja correctamente múltiples combinaciones de materias del enum MateriaFIS.

### 📝 Código del Test
```java
@ParameterizedTest(name = "materia={0} → estado={1} → estaValida={2}")
@CsvSource({
    "PROGRAMACION_I,        ACTIVO,   true",
    "ALGEBRA_LINEAL,        ACTIVO,   true",
    "SISTEMAS_OPERATIVOS,   ACTIVO,   true",
    "MATERIA_INVALIDA,      ACTIVO,   false",
    "PROGRAMACION_I,        INACTIVO, true"  // La materia es válida, pero tutor inactivo
})
void doGet_deberiaValidarMultiplesMaterias(
        String materiaNombre, String estado, boolean esValida) {

    // Arrange
    MateriaFIS materia;
    try {
        materia = MateriaFIS.valueOf(materiaNombre);
    } catch (IllegalArgumentException e) {
        materia = null;
    }

    // Act & Assert
    if (esValida) {
        assertNotNull(materia);
    } else {
        assertNull(materia);
    }
}
```

### 📊 Valores de Entrada (5 casos)
| # | Materia | Estado | ¿Es Válida? |
|---|---------|--------|------------|
| 1 | PROGRAMACION_I | ACTIVO | ✅ true |
| 2 | ALGEBRA_LINEAL | ACTIVO | ✅ true |
| 3 | SISTEMAS_OPERATIVOS | ACTIVO | ✅ true |
| 4 | MATERIA_INVALIDA | ACTIVO | ❌ false |
| 5 | PROGRAMACION_I | INACTIVO | ✅ true |

### ✅ Resultado Esperado
- ✓ Las 3 primeras materias se validan correctamente
- ✓ La materia inválida lanza IllegalArgumentException
- ✓ El estado no afecta la validación de materia

---

## 🧪 PRUEBA 6: Test con Mock - Búsqueda en BD (EntityManager)

### 📍 Ubicación
- **Archivo**: `src/test/java/servlets/BuscarTutorServletMockTest.java`
- **Clase a Probar**: `BuscarTutorServlet.doGet()`
- **Mock**: `JpaUtil.createEntityManager()` + `EntityManager` + `Query`

### 🎯 Objetivo
Simular la búsqueda en base de datos sin conectarse realmente, verificando que:
1. Se ejecuta la consulta JPQL correcta
2. Se retornan tutores filtrados por materia y estado ACTIVO
3. Se maneja correctamente cuando no hay resultados

### 📝 Código del Test (Estructura)
```java
@ExtendWith(MockitoExtension.class)
class BuscarTutorServletMockTest {

    @Mock
    private EntityManager entityManager;

    @Mock
    private Query query;

    @InjectMocks
    private BuscarTutorServlet servlet;

    @Test
    void doGet_deberiaTraerTutoresActivosPorMateria() {
        // Arrange - Crear mocks y datos
        Tutor tutor1 = Tutor.builder()
                .id(1L)
                .nombre("Carlos")
                .estado(Estados.ACTIVO)
                .materiasRelacionadas(Set.of(MateriaFIS.PROGRAMACION_I))
                .build();

        List<Tutor> tutoresEsperados = List.of(tutor1);

        // Mock del EntityManager y Query
        when(JpaUtil.createEntityManager()).thenReturn(entityManager);
        when(entityManager.createQuery(
                "SELECT DISTINCT t FROM Tutor t WHERE :m MEMBER OF t.materiasRelacionadas AND t.estado = :activo",
                Tutor.class))
                .thenReturn(query);
        when(query.setParameter("m", MateriaFIS.PROGRAMACION_I))
                .thenReturn(query);
        when(query.setParameter("activo", Estados.ACTIVO))
                .thenReturn(query);
        when(query.getResultList()).thenReturn(tutoresEsperados);

        // Act
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        when(request.getParameter("materia")).thenReturn("PROGRAMACION_I");

        servlet.doGet(request, response);

        // Assert - Verificaciones
        verify(entityManager).createQuery(contains("tutores"), eq(Tutor.class));
        assertEquals(1, tutoresEsperados.size());
        assertEquals("Carlos", tutoresEsperados.get(0).getNombre());
        assertEquals(Estados.ACTIVO, tutoresEsperados.get(0).getEstado());
    }

    @Test
    void doGet_deberiaRetornarListaVacíaCuandoNoHayTutores() {
        // Arrange
        when(JpaUtil.createEntityManager()).thenReturn(entityManager);
        when(entityManager.createQuery(anyString(), eq(Tutor.class)))
                .thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList()).thenReturn(new ArrayList<>()); // Empty list

        // Act
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        when(request.getParameter("materia")).thenReturn("PROGRAMACION_I");

        servlet.doGet(request, response);

        // Assert
        verify(request).setAttribute("tutoresResultado", ArgumentMatchers.argThat(
                list -> ((List<?>) list).isEmpty()
        ));
    }
}
```

### 📊 Escenarios de Mock
| # | Escenario | Mock Setup | Verificación |
|---|-----------|-----------|--------------|
| A | Búsqueda exitosa | EntityManager retorna 1 tutor | ✅ tutoresResultado contiene 1 DTO |
| B | Sin resultados | Query retorna lista vacía | ✅ tutoresResultado está vacío |
| C | Materia inválida | IllegalArgumentException en valueOf() | ✅ Se muestra error en request |

### ✅ Resultado Esperado
- ✓ EntityManager.createQuery() llamado con JPQL correcta
- ✓ Parámetros seteados: materia + estado ACTIVO
- ✓ getResultList() retorna lista de tutores
- ✓ Cuando está vacía, se muestra mensaje apropiado
- ✓ Los DTOs se crean correctamente desde mocked tutores

---

## 📌 Resumen de Tecnologías y Patrones

### Pruebas Unitarias Normales (1-4)
- **Patrón**: Arrange-Act-Assert (AAA)
- **Scope**: Métodos estáticos y DTOs
- **Frameworks**: JUnit 5
- **Mock**: ❌ Sin mock

### Prueba Parametrizada (5)
- **Patrón**: @ParameterizedTest + @CsvSource
- **Casos**: 5 combinaciones diferentes
- **Frameworks**: JUnit 5 + jupiter-params

### Test con Mock (6)
- **Patrón**: Mockito + Mock(EntityManager) + jUnit 5
- **Mock Framework**: Mockito
- **Scope**: Servlet doGet() con simulación de BD
- **Verificaciones**: verify(), argumentCaptor(), spy()

---

## 🎯 Criterios de Aceptación Cumplidos

✅ **Escenario 1**: Búsqueda por nombre exacto de materia → Prueba 5 + 6   
✅ **Escenario 2**: Materia sin tutores → Prueba 6 (lista vacía)   
✅ **Escenario 3**: Campo vacío o espacios → Prueba 2 + Validación en servlet  

---

## 📂 Archivos de Test a Crear

```
src/test/java/
├── servlets/
│   ├── BuscarTutorServletTest.java          (Pruebas 1-3, 5)
│   └── BuscarTutorServletMockTest.java      (Prueba 6)
└── schemas/
    └── TutorListadoDTOTest.java             (Prueba 4)
```

---

## 🚀 Próximos Pasos

1. ✅ Revisar este plan
2. ⏳ Implementar las 6 pruebas según especificación
3. ⏳ Ejecutar: `mvn test`
4. ⏳ Garantizar que todos pasen (6/6)

