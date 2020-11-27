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
    // Part III. Random numbers
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

}
