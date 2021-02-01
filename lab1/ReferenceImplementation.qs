// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks.
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.lab1 {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Math;


    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // Task 1.1. State flip
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal: Change the state of the qubit to α |1⟩ + β |0⟩.
    // Example:
    //     If the qubit is in state |0⟩, change its state to |1⟩.
    //     If the qubit is in state |1⟩, change its state to |0⟩.
    operation StateFlip_Reference (q : Qubit) : Unit is Adj+Ctl {
        X(q);
    }


    // Task 1.2. Basis change: |0⟩ to |+⟩ and |1⟩ to |-⟩ (and vice versa)
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal: Change the state of the qubit as follows:
    //     If the qubit is in state |0⟩, change its state to |+⟩ = (|0⟩ + |1⟩) / sqrt(2).
    //     If the qubit is in state |1⟩, change its state to |-⟩ = (|0⟩ - |1⟩) / sqrt(2).
    //     If the qubit is in superposition, change its state according to the effect on basis vectors.
    // Note: |+⟩ and |-⟩ form a different basis for single-qubit states, called X basis.
    operation BasisChange_Reference (q : Qubit) : Unit is Adj+Ctl {
        H(q);
    }


    // Task 1.3. Sign flip: |+⟩ to |-⟩ and vice versa.
    // Inputs: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal: Change the qubit state to α |0⟩ - β |1⟩ (flip the sign of |1⟩ component of the superposition).
    operation SignFlip_Reference (q : Qubit) : Unit is Adj+Ctl {
        Z(q);
    }

    //Task 1.4 Mulitple gates: |0⟩ to |-⟩ and |1⟩ to |+⟩
    operation MultipleGates_Reference (q : Qubit) : Unit is Adj+Ctl {
        H(q);
        X(q);
    }



    //////////////////////////////////////////////////////////////////
    // Part II. Random numbers
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    operation RandomBit_Reference () : Int {
        using (q = Qubit()) {
            H(q);
            return M(q) == Zero ? 0 | 1;
        }
    }

    // Exercise 2. 
    operation RandomTwoBits_Reference () : Int {
        return 2 * RandomBit_Reference() + RandomBit_Reference();
    }

    // Exercise 3.
    operation RandomNBits_Reference (N: Int) : Int {
        mutable result = 0;
        for (i in 0..(N - 1)) {
            set result = result * 2 + RandomBit_Reference();
        }
        return result;
    }

    //////////////////////////////////////////////////////////////////
    // Part III. Deutsch–Jozsa Algorithm 
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    operation PhaseOracle_MostSignificantBit_Reference (x : Qubit[]) : Unit is Adj {
        Z(x[0]);
    }

    // Exercise 2.
    operation PhaseOracle_Zero (x : Qubit[]) : Unit {
    // Do nothing...
    }

    operation PhaseOracle_One (x : Qubit[]) : Unit {
        // Apply a global phase of -1
        R(PauliI, 2.0 * PI(), x[0]);
    }

    operation PhaseOracle_Xmod2 (x : Qubit[]) : Unit {
        // Length(x) gives you the length of the array.
        // Array elements are indexed 0 through Length(x)-1, inclusive.
        Z(x[Length(x) - 1]);
    }

    operation PhaseOracle_OddNumberOfOnes (x : Qubit[]) : Unit {
        ApplyToEach(Z, x);
    }

    // Function 1. f(x) = 0
    operation PhaseOracle_Zero_Reference (x : Qubit[]) : Unit is Adj {
        // Since f(x) = 0 for all values of x, Uf|y⟩ = |y⟩.
        // This means that the operation doesn't need to do any transformation to the inputs.
        // Build the project and run the tests to see that T01_Oracle_Zero test passes.
    }


    // Function 2. f(x) = 1
    operation PhaseOracle_One_Reference (x : Qubit[]) : Unit is Adj {
        // Since f(x) = 1 for all values of x, Uf|y⟩ = -|y⟩.
        // This means that the operation needs to add a global phase of -1.
        R(PauliI, 2.0 * PI(), x[0]);
    }


    // Function 3. f(x) = x mod 2
    operation PhaseOracle_Xmod2_Reference (x : Qubit[]) : Unit is Adj {
        // Length(x) gives you the length of the array.
        // Array elements are indexed 0 through Length(x)-1, inclusive.
        Z(x[Length(x) - 1]);
    }


    // Function 4. f(x) = 1 if x has odd number of 1s, and 0 otherwise
    operation PhaseOracle_OddNumberOfOnes_Reference (x : Qubit[]) : Unit is Adj {
        ApplyToEachA(Z, x);
    }


    operation DeutschJozsaAlgorithm_Reference (N : Int, oracle : (Qubit[] => Unit)) : Bool {
        mutable isConstantFunction = true;
        using (x = Qubit[N]) {
            ApplyToEach(H, x);
            oracle(x);
            ApplyToEach(H, x);
            for (q in x) {
                if (M(q) == One) {
                    set isConstantFunction = false;
                }
            }
        }
        return isConstantFunction;
    }
}
