
---

### src/infinite_light.py

```python
# infinite_light.py
# Encodes the "infinite light" amplifier Γ(c) and force constructs.

from dataclasses import dataclass
from math import sqrt
from typing import Optional

# Physical constants (SI)
C = 299_792_458.0           # speed of light, m/s
H_BAR = 1.054_571_817e-34   # reduced Planck constant, J*s
E_CHARGE = 1.602_176_634e-19  # Coulomb
M_E = 9.109_383_7015e-31    # electron mass, kg
A0 = 5.291_772_10903e-11    # Bohr radius, m
E_H_EV = 13.605_693_122994  # Hartree/2 (hydrogen ground binding), eV

@dataclass
class InfiniteLightAmplifier:
    """
    Dimensionless amplifier Γ(c) that diverges as operational speed u → c.
    Interprets c^∞ as a limit-based intensifier without breaking units.
    """
    u: float = 0.0          # operational speed scale (m/s), must be < c
    c: float = C            # speed of light (m/s)

    def gamma(self) -> float:
        if not (0.0 <= self.u < self.c):
            raise ValueError("u must satisfy 0 ≤ u < c")
        return 1.0 / sqrt(1.0 - (self.u**2) / (self.c**2))

    def amplify_frequency(self, omega: float) -> float:
        """Scale angular frequency ω by Γ(c)."""
        return self.gamma() * omega

    def infinite_force(self, m: float, a: float) -> float:
        """F_∞ = Γ(c) * m * a"""
        return self.gamma() * m * a

@dataclass
class SpectralScaler:
    """
    Utility for scaling energies and frequencies with Γ(c).
    """
    amp: InfiniteLightAmplifier

    def scale_energy(self, E: float) -> float:
        """Scale energy-like quantity by Γ(c)."""
        return self.amp.gamma() * E

    def scale_frequency(self, omega: float) -> float:
        """Scale angular frequency by Γ(c)."""
        return self.amp.amplify_frequency(omega)

def omega_from_period(T: float) -> float:
    """ω = 2π / T"""
    from math import pi
    if T <= 0:
        raise ValueError("Period T must be positive.")
    return 2.0 * pi / T

def energy_harmonic_level(n: int, omega: float) -> float:
    """
    E_n = ħ ω (n + 1/2), returns Joules.
    """
    if n < 0:
        raise ValueError("n must be ≥ 0")
    return H_BAR * omega * (n + 0.5)

def hydrogen_energy_ev(n: int) -> float:
    """
    Hydrogen-like energy level in eV (Bohr model):
    E_n = -13.6 eV / n^2
    """
    if n <= 0:
        raise ValueError("n must be a positive integer")
    return -E_H_EV / (n**2)

def bohr_radius_Z(Z: int = 1) -> float:
    """
    Bohr radius for nuclear charge Z: a0/Z.
    """
    if Z <= 0:
        raise ValueError("Z must be ≥ 1")
    return A0 / Z
