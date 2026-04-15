package main;

public class CuentaBancaria {
    private String titular;
    private double saldo;

    public CuentaBancaria(String titular, double saldo) {
        this.titular = titular;
        this.saldo = saldo;
    }

    public String getTitular() {
        return titular;
    }

    public void setTitular(String titular) {
        this.titular = titular;
    }

    public double getSaldo() {
        return saldo;
    }

    public void setSaldo(double saldo) {
        this.saldo = saldo;
    }

    public void depositar(double cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad no puede ser 0 ni negativa");
        }
        if (cantidad > saldo) {
            throw new IllegalArgumentException("Fondos insuficientes");
        }
        setSaldo(getSaldo() - cantidad);
    }

    public void retirar(double cantidad) {
        if (cantidad <= 0) {
            throw new IllegalArgumentException("La cantidad a retirar debe ser positiva");
        }
        if (cantidad > saldo) {
            throw new IllegalArgumentException("Fondos insuficientes.");
        }
        saldo -= cantidad;
    }
}
