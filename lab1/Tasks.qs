// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.BasicGates {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;


    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // "Basic Gates" quantum kata is a series of exercises designed
    // to get you familiar with the basic quantum gates in Q#.
    // It covers the following topics:
    //  - basic single-qubit and multi-qubit gates,
    //  - adjoint and controlled gates,
    //  - using gates to modify the state of a qubit.

    // Each task is wrapped in one operation preceded by the description of the task.
    // Each task (except tasks in which you have to write a test) has a unit test associated with it,
    // which initially fails. Your goal is to fill in the blank (marked with // ... comment)
    // with some Q# code to make the failing test pass.

    // Most tasks can be done using exactly one gate.
    // None of the tasks require measurement, and the tests are written so as to fail if qubit state is measured.

    // The tasks are given in approximate order of increasing difficulty; harder ones are marked with asterisks.


    //////////////////////////////////////////////////////////////////
    // Part I. Single-Qubit Gates
    //////////////////////////////////////////////////////////////////

    // Note that all operations in this section have `is Adj+Ctl` in their signature.
    // This means that they should be implemented in a way that allows Q# 
    // to compute their adjoint and controlled variants automatically.
    // Since each task is solved using only intrinsic gates, you should not need to put any special effort in this.


    // Task 1.1. State flip: |0⟩ to |1⟩ and vice versa
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the state of the qubit to α |1⟩ + β |0⟩.
    // Example:
    //        If the qubit is in state |0⟩, change its state to |1⟩.
    //        If the qubit is in state |1⟩, change its state to |0⟩.
    // Note that this operation is self-adjoint: applying it for a second time
    // returns the qubit to the original state.
    operation StateFlip (q : Qubit) : Unit is Adj+Ctl {
        // The Pauli X gate will change the |0⟩ state to the |1⟩ state and vice versa.
        // Type X(q);
        // Then rebuild the project and rerun the tests - T101_StateFlip should now pass!

        // ...
    }


    // Task 1.2. Basis change: |0⟩ to |+⟩ and |1⟩ to |-⟩ (and vice versa)
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the state of the qubit as follows:
    //        If the qubit is in state |0⟩, change its state to |+⟩ = (|0⟩ + |1⟩) / sqrt(2).
    //        If the qubit is in state |1⟩, change its state to |-⟩ = (|0⟩ - |1⟩) / sqrt(2).
    //        If the qubit is in superposition, change its state according to the effect on basis vectors.
    // Note:  |+⟩ and |-⟩ form a different basis for single-qubit states, called X basis.
    // |0⟩ and |1⟩ are called Z basis.
    operation BasisChange (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    // Task 1.3. Sign flip: |+⟩ to |-⟩ and vice versa.
    // Input: A qubit in state |ψ⟩ = α |0⟩ + β |1⟩.
    // Goal:  Change the qubit state to α |0⟩ - β |1⟩ (flip the sign of |1⟩ component of the superposition).
    operation SignFlip (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }

    //Task 1.4 Mulitple gates: |0⟩ to |-⟩ and |1⟩ to |+⟩
    operation MultipleGates (q : Qubit) : Unit is Adj+Ctl {
        // ...
    }


    
    //////////////////////////////////////////////////////////////////
    // Part III. Random numbers
    //////////////////////////////////////////////////////////////////

    // Exercise 1.
    operation RandomBit () : Int {
        using (q = Qubit()) {
            // ...
            return -1;
        }
    }

    // Exercise 2.
    operation RandomTwo () : Int {
        //..
        return -1;
    }

    // Exercise 3.
    operation RandomTwoBits () : Int {
        // ...
        return -1;
    }

    // Exercise 4.
    operation RandomNBits (N: Int) : Int {
        // ...
        return -1;
    }
}
