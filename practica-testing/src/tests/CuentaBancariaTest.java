package tests;

import main.CuentaBancaria;
import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

public class CuentaBancariaTest {

    private CuentaBancaria cuenta;

    @Before
    public void setUp() {
        // Cuenta base que uso en casi todos los tests: titular Roberto, saldo 1000
        cuenta = new CuentaBancaria("Roberto Ponce Paniagua", 1000.0);
    }

    // Test comprobación: verificar que el titular se asigna correctamente
    @Test
    public void testGetTitularCorrecto() {
        assertEquals("Roberto Ponce Paniagua", cuenta.getTitular());
    }

    // Si ingreso 500€, el saldo debe pasar de 1000 a 1500
    @Test
    public void testDepositoValidoIncrementaSaldo() {
        cuenta.depositar(500.0);
        assertEquals(1500.0, cuenta.getSaldo(), 0.001);
    }

    // Si retiro 300€, el saldo debe quedar en 700
    @Test
    public void testRetiroValidoDisminuyeSaldo() {
        cuenta.retirar(300.0);
        assertEquals(700.0, cuenta.getSaldo(), 0.001);
    }

    // Caso límite: retirar exactamente lo que hay deja la cuenta vacía, no en negativo
    @Test
    public void testRetirarTodoElSaldoDejaACero() {
        cuenta.retirar(1000.0);
        assertEquals(0.0, cuenta.getSaldo(), 0.001);
    }

    // No tiene sentido depositar dinero negativo, debe lanzar excepción
    @Test(expected = IllegalArgumentException.class)
    public void testDepositoNegativoLanzaExcepcion() {
        cuenta.depositar(-100.0);
    }

    // Tampoco se puede retirar más de lo que hay en cuenta
    @Test(expected = IllegalArgumentException.class)
    public void testRetiroMayorQueSaldoLanzaExcepcion() {
        cuenta.retirar(2000.0);
    }

    // Depositar exactamente cero no tiene sentido, debe rechazarse
    @Test(expected = IllegalArgumentException.class)
    public void testDepositoCeroEsInvalido() {
        cuenta.depositar(0.0);
    }

    // Igual que depositar, retirar cero no es una operación válida
    @Test(expected = IllegalArgumentException.class)
    public void testRetiroCeroEsInvalido() {
        cuenta.retirar(0.0);
    }

    // Compruebo que el mensaje de error por fondos insuficientes es exactamente el esperado
    @Test
    public void testMensajeErrorFondosInsuficientes() {
        try {
            cuenta.retirar(9999.0);
            fail("Debería haber lanzado IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            assertEquals("Fondos insuficientes.", e.getMessage());
        }
    }

    // El mensaje cuando se intenta depositar un importe negativo también debe ser preciso
    @Test
    public void testMensajeErrorDepositoInvalido() {
        try {
            cuenta.depositar(-50.0);
            fail("Debería haber lanzado IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            assertEquals("La cantidad a depositar debe ser mayor que cero.", e.getMessage());
        }
    }

    // Verifico que el constructor asigna bien el saldo inicial con otra cuenta distinta
    @Test
    public void testConstructorAsignaSaldoInicial() {
        CuentaBancaria otraCuenta = new CuentaBancaria("Roberto Ponce Paniagua", 250.0);
        assertEquals(250.0, otraCuenta.getSaldo(), 0.001);
    }
}