# build_atom.py
# Example: construct and print a quantum atom under the Infinite Light model.

from pprint import pprint

from src.quantum_atom import QuantumAtom

def main():
    # Configure the atom:
    # - Z=1 (hydrogen-like)
    # - u = 0.99 c fraction to showcase Γ(c) blowing up
    # - levels = 5 bound levels
    # - base_period_T = optional (comment it out to use Compton-like ω)
    atom = QuantumAtom(
        Z=1,
        base_period_T=None,   # or set e.g., T=1e-15
        u=0.99 * 299_792_458.0,
        levels=5,
        scale_hydrogen=False  # set True to apply symbolic Γ scaling to hydrogen energies
    )

    summary = atom.build()

    print("\n=== Quantum Atom — Infinite Light Edition ===")
    pprint(summary)

if __name__ == "__main__":
    main()
