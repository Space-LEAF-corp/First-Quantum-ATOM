import math

from src.infinite_light import (
    C,
    InfiniteLightAmplifier,
    SpectralScaler,
    omega_from_period,
    energy_harmonic_level,
    hydrogen_energy_ev,
    bohr_radius_Z,
)
from src.quantum_atom import QuantumAtom


def test_infinite_light_gamma_and_scaler():
    amp = InfiniteLightAmplifier(u=0.0, c=C)
    assert math.isclose(amp.gamma(), 1.0, rel_tol=1e-12)

    omega = 2.0 * math.pi
    assert math.isclose(amp.amplify_frequency(omega), omega, rel_tol=1e-12)

    scaler = SpectralScaler(amp=amp)
    assert math.isclose(scaler.scale_frequency(omega), omega, rel_tol=1e-12)


def test_quantum_atom_build_basic():
    atom = QuantumAtom(Z=1, base_period_T=1e-15, u=0.0, levels=3, scale_hydrogen=False)
    summary = atom.build()

    assert summary["Z"] == 1
    assert "gamma" in summary and math.isfinite(summary["gamma"]) 
    assert "oscillator" in summary and "levels_J" in summary["oscillator"]
    assert len(summary["oscillator"]["levels_J"]) == 3
    assert len(summary["hydrogen_like"]["levels_eV"]) == 3
    # Hydrogen levels should be negative (bound states)
    assert all(E < 0 for E in summary["hydrogen_like"]["levels_eV"]) 


def test_imports_work():
    # import should succeed and classes should be callable
    amp = InfiniteLightAmplifier(u=0.0, c=C)
    assert isinstance(amp, InfiniteLightAmplifier)

    atom = QuantumAtom()
    assert isinstance(atom, QuantumAtom)


def test_infinite_light_invalid_u():
    # Negative u or u >= c should raise ValueError
    with __import__('pytest').raises(ValueError):
        InfiniteLightAmplifier(u=-1.0, c=C).gamma()
    with __import__('pytest').raises(ValueError):
        InfiniteLightAmplifier(u=C, c=C).gamma()


def test_omega_from_period_and_harmonic_errors():
    with __import__('pytest').raises(ValueError):
        omega_from_period(0.0)
    with __import__('pytest').raises(ValueError):
        energy_harmonic_level(-1, 1.0)


def test_hydrogen_and_bohr_errors():
    with __import__('pytest').raises(ValueError):
        hydrogen_energy_ev(0)
    with __import__('pytest').raises(ValueError):
        bohr_radius_Z(0)


def test_scaler_energy():
    amp = InfiniteLightAmplifier(u=0.0, c=C)
    scaler = SpectralScaler(amp=amp)
    E = -13.6
    assert math.isclose(scaler.scale_energy(E), E, rel_tol=1e-12)
