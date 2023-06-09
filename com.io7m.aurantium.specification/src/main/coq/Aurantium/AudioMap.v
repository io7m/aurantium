(*
 * Copyright © 2023 Mark Raynsford <code@io7m.com> https://www.io7m.com
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
 * IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

Require Import Coq.Lists.List.
Require Import Coq.Init.Nat.

Import ListNotations.

Require Import Aurantium.Compatibility.
Require Import Aurantium.Identifier.
Require Import Aurantium.Clip.
Require Import Aurantium.KeyMapping.

(** The key assignment _k_ references clip _s_. *)
Definition keyAssignmentReferencesClip
  (k : keyAssignment)
  (s : clip)
: Prop :=
  (kaClipId k) = (clipId s).

(** The clip referenced by _k_ exists in _s_. *)
Definition keyAssignmentReferencesExists
  (k : keyAssignment)
  (s : clips)
: Prop :=
  exists p, keyAssignmentReferencesClip k p /\ In p (clipsList s).

(** All key assignment in _k_ reference clips that exist in _s_. *)
Definition keyAssignmentsReferences
  (k : keyAssignments)
  (s : clips)
: Prop :=
  forall p, In p (kasList k) -> keyAssignmentReferencesExists p s.

(** Every clip in _ss_ has at least one reference in _k_. *)
Definition clipsReferenced
  (k  : keyAssignments)
  (ss : clips)
: Prop :=
  Forall (fun s => exists a, keyAssignmentReferencesClip a s /\ In s (clipsList ss)) (clipsList ss).

Inductive audioMap : Set := {
  amIdentifier               : identifier;
  amClips                    : clips;
  amKeyAssignments           : keyAssignments;
  amKeyAssignmentsReferences : keyAssignmentsReferences amKeyAssignments amClips;
  amClipsReferenced          : clipsReferenced amKeyAssignments amClips;
}.

