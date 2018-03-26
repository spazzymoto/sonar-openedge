/*******************************************************************************
 * Original work Copyright (c) 2003-2015 John Green
 * Modified work Copyright (c) 2015-2018 Riverside Software
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    John Green - initial API and implementation and/or initial documentation
 *    Gilles Querret - Almost anything written after 2015
 *******************************************************************************/ 
package org.prorefactor.core;

public class ProparseRuntimeException extends RuntimeException {
  private static final long serialVersionUID = -1350324743265891607L;

  public ProparseRuntimeException(String message) {
    super(message);
  }

  public ProparseRuntimeException(Throwable cause) {
    super(cause);
  }
}
